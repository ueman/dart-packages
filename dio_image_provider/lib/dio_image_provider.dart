library dio_image_provider;

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

/// Fetches the given URL from the network, associating it with the given scale.
///
/// The image will be cached regardless of cache headers from the server.
///
/// See also:
///
///  * [Image.network].
///  * https://pub.dev/packages/http_image_provider
@immutable
class DioImage extends ImageProvider<DioImage> {
  static Dio defaultDio = Dio();

  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments [url] and [scale] must not be null.
  /// [dio] will be the default [Dio] if not set.
  DioImage.string(String url, {this.scale = 1.0, this.headers, Dio? dio})
      : dio = dio ?? defaultDio,
        url = Uri.parse(url);

  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments [url] and [scale] must not be null.
  /// [dio] will be the default [Dio] if not set.
  DioImage(this.url, {this.scale = 1.0, this.headers, Dio? dio})
      : dio = dio ?? defaultDio;

  /// The URL from which the image will be fetched.
  final Uri url;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  /// The HTTP headers that will be used with [HttpClient.get] to fetch image from network.
  ///
  /// When running flutter on the web, headers are not used.
  final Map<String, String>? headers;

  /// [dio] will be the default [Dio] if not set.
  final Dio dio;

  @override
  Future<DioImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DioImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(DioImage key, ImageDecoderCallback decode) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final chunkEvents = StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url.toString(),
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<DioImage>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    DioImage key,
    StreamController<ImageChunkEvent> chunkEvents,
    ImageDecoderCallback decode,
  ) async {
    try {
      assert(key == this);

      final response = await dio.getUri<dynamic>(
        url,
        options: Options(headers: headers, responseType: ResponseType.bytes),
        onReceiveProgress: (count, total) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: count,
            expectedTotalBytes: total >= 0 ? total : null,
          ));
        },
      );

      if (response.statusCode != 200) {
        throw NetworkImageLoadException(
          uri: url,
          statusCode: response.statusCode!,
        );
      }

      final bytes = Uint8List.fromList(response.data as List<int>);

      if (bytes.lengthInBytes == 0) {
        throw NetworkImageLoadException(
          uri: url,
          statusCode: response.statusCode!,
        );
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
      unawaited(chunkEvents.close());
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DioImage && other.url == url && other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'DioImage')}("$url", scale: $scale)';
}
