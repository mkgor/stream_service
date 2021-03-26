import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:stream_service/stream_service.dart';

void main() {
  test('creating new stream', () {
    final streamService = StreamService();

    streamService.add<String>('test-stream');

    var stream = streamService.get('test-stream');

    expect(stream.runtimeType, Stream);
  });

  test('emitting new event', () {
    final streamService = StreamService();

    streamService.add<String>('test-stream');

    streamService.listen<String>('test-stream', (event) {
      expect('test', event);
    });

    streamService.emit('test-stream', 'test');
  });
}

