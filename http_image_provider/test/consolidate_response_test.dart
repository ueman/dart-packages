import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http_image_provider/consolidate_response.dart';

final Uint8List chunkOne = Uint8List.fromList(<int>[0, 1, 2, 3, 4, 5]);
final Uint8List chunkTwo = Uint8List.fromList(<int>[6, 7, 8, 9, 10]);

void main() {
  group(consolidateStreamedResponseBytes, () {
    late MockStreamedResponse response;

    setUp(() {
      response = MockStreamedResponse(chunkOne: chunkOne, chunkTwo: chunkTwo);
    });

    test('Converts an StreamedResponse with contentLength to bytes', () async {
      response.contentLength = chunkOne.length + chunkTwo.length;
      final List<int> bytes = await consolidateStreamedResponseBytes(response);

      expect(bytes, <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    });

    test('Converts a compressed StreamedResponse with contentLength to bytes',
        () async {
      response.contentLength = chunkOne.length;
      final List<int> bytes = await consolidateStreamedResponseBytes(response);

      expect(bytes, <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    });

    test('Converts an StreamedResponse without contentLength to bytes',
        () async {
      response.contentLength = -1;
      final List<int> bytes = await consolidateStreamedResponseBytes(response);

      expect(bytes, <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    });

    test('Notifies onBytesReceived for every chunk of bytes', () async {
      final int syntheticTotal = (chunkOne.length + chunkTwo.length) * 2;
      response.contentLength = syntheticTotal;
      final List<int?> records = <int?>[];
      await consolidateStreamedResponseBytes(
        response,
        onBytesReceived: (int cumulative, int? total) {
          records.addAll(<int?>[cumulative, total]);
        },
      );

      expect(records, <int>[
        chunkOne.length,
        syntheticTotal,
        chunkOne.length + chunkTwo.length,
        syntheticTotal,
      ]);
    });

    test('forwards errors from StreamedResponse', () async {
      response = MockStreamedResponse(error: Exception('Test Error'));
      response.contentLength = -1;

      expect(consolidateStreamedResponseBytes(response), throwsException);
    });

    test('Propagates error to Future return value if onBytesReceived throws',
        () async {
      response.contentLength = -1;
      final Future<List<int>> result = consolidateStreamedResponseBytes(
        response,
        onBytesReceived: (int cumulative, int? total) {
          throw 'misbehaving callback';
        },
      );

      expect(result, throwsA(equals('misbehaving callback')));
    });
  });
}

class MockStreamedResponse extends Fake implements StreamedResponse {
  MockStreamedResponse({
    this.error,
    this.chunkOne = const <int>[],
    this.chunkTwo = const <int>[],
  });

  final dynamic error;
  final List<int> chunkOne;
  final List<int> chunkTwo;

  @override
  int contentLength = 0;

  @override
  ByteStream get stream {
    if (error != null) {
      return ByteStream(Stream<List<int>>.fromFuture(
        Future<List<int>>.error(error as Object),
      ));
    }
    return ByteStream(Stream<List<int>>.fromIterable(<List<int>>[
      chunkOne,
      chunkTwo,
    ]));
  }
}
