import 'package:flutter/material.dart';
import 'package:stream_service/stream_service.dart';

var streamService = StreamService();

void main() {
  runApp(MyApp());

  streamService.add<int>('demo-stream');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamServiceDemoPage(title: 'StreamService demo'),
    );
  }
}

// ignore: must_be_immutable
class StreamServiceDemoPage extends StatelessWidget {
  StreamServiceDemoPage({this.title});

  final String title;
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: streamService.get('demo-stream'),
              builder: (context, snapshot) {
                return RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 24.0),
                    text: 'Counter value is: ',
                    children: [
                      TextSpan(
                        text: snapshot.data?.toString() ?? "0",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => streamService.emit('demo-stream', counter += 1),
        tooltip: 'Increment value',
        child: Icon(Icons.add_outlined),
      ),
    );
  }
}
