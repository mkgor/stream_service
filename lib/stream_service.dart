import 'dart:async';

class StreamService {
  final bool enableDebugPrints;

  StreamService({
    this.enableDebugPrints =
        const bool.fromEnvironment('dart.vm.product', defaultValue: false),
  });

  Map<String, StreamController> _streamControllers =
      <String, StreamController>{};

  Map<String, Stream> _cachedStreams = <String, Stream>{};

  ///
  /// Creating new StreamController with specified type
  ///
  void add<T>(String key) {
    assert(!_streamControllers.containsKey(key));

    _debugPrint("Created stream", stream: key);
    _streamControllers[key] = StreamController<T>();
  }

  ///
  /// Emitting event into stream
  ///
  void emit(String key, dynamic data) {
    assert(_streamControllers.containsKey(key));

    _debugPrint("Emitted new event with data: $data", stream: key);

    _streamControllers[key].add(data);
  }

  ///
  /// Getting stream by specified key
  ///
  Stream get(String key) {
    assert(_streamControllers.containsKey(key));

    if (!_cachedStreams.containsKey(key)) {
      _cachedStreams[key] = _streamControllers[key].stream.asBroadcastStream();
    }

    return _cachedStreams[key];
  }

  ///
  /// Creating listener for stream with specified type
  ///
  /// Creating a listener via get(key).listen is not recommended, because type of event
  /// will be dynamic
  ///
  StreamSubscription<T> listen<T>(String key, void listener(T event)) {
    assert(_streamControllers.containsKey(key));

    return get(key).listen((event) => listener(event));
  }

  ///
  /// Getting stream controller by key
  ///
  StreamController getStreamController(String key) {
    assert(_streamControllers.containsKey(key));

    return _streamControllers[key];
  }

  ///
  /// Closing stream and removing it from streams map
  ///
  void remove(String key) {
    assert(_streamControllers.containsKey(key));

    if (!_streamControllers[key].isClosed) _streamControllers[key].close();

    _streamControllers.remove(key);

    _debugPrint("Closed stream", stream: key);
  }

  void dispose() {
    /// Closing all existing streams
    ///
    _streamControllers.forEach((key, value) {
      value.close();
    });

    _streamControllers = <String, StreamController>{};

    _debugPrint("Stream service disposed");
  }

  void _debugPrint(String message, {String stream}) {
    if (enableDebugPrints)
      print(
          "[STREAM SERVICE] $message ${stream != null ? "(target stream: $stream)" : null}");
  }
}
