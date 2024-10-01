import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_image_provider/http_image_provider.dart';
import 'package:http/testing.dart';

class _NoOpCodec implements ui.Codec {
  @override
  void dispose() {}

  @override
  int get frameCount => throw UnimplementedError();

  @override
  Future<ui.FrameInfo> getNextFrame() => throw UnimplementedError();

  @override
  int get repetitionCount => throw UnimplementedError();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test('load image', () async {
    late int pngLength;

    final client = MockClient((request) async {
      final response = MockClient.pngResponse(request: request);
      pngLength = response.contentLength!;
      return response;
    });

    final provider = HttpImageProvider(Uri.parse('https://example.com/cat.png'),
        client: client);
    final key = await provider.obtainKey(ImageConfiguration.empty);

    final decoderCompleter = Completer<void>();

    provider.loadImage(key, (
      ui.ImmutableBuffer buffer, {
      ui.TargetImageSizeCallback? getTargetSize,
    }) {
      if (pngLength == buffer.length) decoderCompleter.complete();
      decoderCompleter.completeError('unexpected buffer length: '
          'expected $pngLength, got ${buffer.length}');
      return Future<ui.Codec>.value(_NoOpCodec());
    });

    await decoderCompleter.future;
  });
}
