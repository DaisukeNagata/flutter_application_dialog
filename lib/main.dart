import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_dialog/slide_up_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SlideUpController _slideUpController = SlideUpController();
  StreamController _streamController = StreamController.broadcast();

  String _tex = 'drag&drop';
  final String _dataSet = '背面のデータ';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Draggable(
              data: _dataSet,
              feedback: Material(
                child: Text(_dataSet),
              ),
              childWhenDragging: Text(_dataSet),
              child: Text(_dataSet),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_streamController.hasListener) {
                  _streamController.close();
                  _streamController = StreamController.broadcast();
                }
                _slideUpController.show(
                  context,
                  Container(
                      height: MediaQuery.of(context).size.height / 2,

                      // set size
                      color: Colors.blue,

                      // set color
                      child: Container(
                          alignment: Alignment.center,
                          child: StreamBuilder(
                            stream: _streamController.stream,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return Material(
                                child: DragTarget(
                                  onAccept: (data) {
                                    setState(() {
                                      _tex = data.toString();
                                    });
                                  },
                                  builder: (BuildContext context,
                                      List<Object?> candidateData,
                                      List<dynamic> rejectedData) {
                                    return Text(
                                      _tex,
                                      style: const TextStyle(fontSize: 24),
                                    );
                                  },
                                ),
                              );
                            },
                          ))),
                  200, // set speed
                );
              },
              child: const Text('Show Overlay'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _tex = 'drag&drop';
                });
                _streamController.sink.add(0);
              },
              child: const Text('Clear Data'),
            ),
          ],
        ),
      ),
    );
  }
}
