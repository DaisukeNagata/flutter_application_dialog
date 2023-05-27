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
  var y = 0.0;
  var bottom = 0.0;
  final _buttonHeight = 60.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bottom = MediaQuery.of(context).viewInsets.bottom;
  }

  Stream<double> numberStream() async* {
    while (y == 0.0) {
      await Future.delayed(const Duration(milliseconds: 400));
      yield y = bottom + _buttonHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter',
          ),
          onTap: () {
            _slideUpController.show(
              context,
              StreamBuilder(
                  stream: numberStream(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Material(
                      child: Container(
                        color: Colors.black12,
                        height: y,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                y = 0;
                                _slideUpController.show(
                                    context, const SizedBox(), 1000);
                                FocusScope.of(context).unfocus();
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                color: Colors.grey,
                                width: MediaQuery.of(context).size.width,
                                height: _buttonHeight,
                                child: const Text('Close'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              200, // set speed
            );
          },
        ),
      ),
    );
  }
}
