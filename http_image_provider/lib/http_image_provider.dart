library http_image_provider;

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:http_image_provider/consolidate_response.dart';

/// Fetches the given URL from the network, associating it with the given scale.
///
/// The image will be cached regardless of cache headers from the server.
///
/// See also:
///
///  * [Image.network].
///  * https://pub.dev/packages/dio_image_provider
///  * https://github.com/dart-lang/http/tree/master/pkgs/flutter_http_example
@immutable
class HttpImageProvider extends ImageProvider<HttpImageProvider> {
  /// Can be set to override the default [Client] for the
  /// [HttpImageProvider].
  static Client defaultClient = Client();

  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments [url] and [scale] must not be null.
  /// [client] will be the default [Client] if not set.
  HttpImageProvider.string(String url,
      {this.scale = 1.0, this.headers, Client? client})
      : client = client ?? defaultClient,
        url = Uri.parse(url);

  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments [url] and [scale] must not be null.
  /// [client] will be the default [Client] if not set.
  HttpImageProvider(this.url, {this.scale = 1.0, this.headers, Client? client})
      : client = client ?? defaultClient;

  /// The URL from which the image will be fetched.
  final Uri url;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  /// The HTTP headers that will be used with [Client.get] to fetch image from network.
  ///
  /// When running flutter on the web, headers are not used.
  final Map<String, String>? headers;

  /// [client] will be the default [Client] if not set.
  final Client client;

  @override
  Future<HttpImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<HttpImageProvider>(this);

  @override
  ImageStreamCompleter loadImage(
      HttpImageProvider key, ImageDecoderCallback decode) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url.toString(),
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<HttpImageProvider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    HttpImageProvider key,
    StreamController<ImageChunkEvent> chunkEvents,
    ImageDecoderCallback decode,
  ) async {
    try {
      assert(key == this);

      final request = Request('GET', url);
      final addHeaders = headers;
      if (addHeaders != null) {
        request.headers.addAll(addHeaders);
      }
      final response = await client.send(request);

      if (response.statusCode != 200) {
        // The network may be only temporarily unavailable, or the file will be
        // added on the server later. Avoid having future calls to resolve
        // fail to check the network again.
        await response.stream.drain<List<int>>(<int>[]);
        throw NetworkImageLoadException(
          uri: url,
          statusCode: response.statusCode,
        );
      }

      final bytes = await consolidateStreamedResponseBytes(
        response,
        onBytesReceived: (int cumulative, int? total) {
          chunkEvents.add(
            ImageChunkEvent(
              cumulativeBytesLoaded: cumulative,
              expectedTotalBytes: total,
            ),
          );
        },
      );
      if (bytes.lengthInBytes == 0) {
        throw Exception('NetworkImage is an empty file: $url');
      }

      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      return decode(buffer);
    } catch (e) {
      // Depending on where the exception was thrown, the image cache may not
      // have had a chance to track the key in the cache at all.
      // Schedule a microtask to give the cache a chance to add the key.
      scheduleMicrotask(() {
        PaintingBinding.instance.imageCache.evict(key);
      });
      rethrow;
    } finally {
      chunkEvents.close();
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is HttpImageProvider &&
        other.url == url &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'HttpImageProvider')}("$url", scale: ${scale.toStringAsFixed(1)})';
}
