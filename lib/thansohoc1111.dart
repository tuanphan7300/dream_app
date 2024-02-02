import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NumberDisplay(),
    );
  }
}

class NumberDisplay extends StatefulWidget {
  @override
  _NumberDisplayState createState() => _NumberDisplayState();
}

class _NumberDisplayState extends State<NumberDisplay> {
  int number = 0;

  void _incrementNumber() {
    setState(() {
      number++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Number Display'),
      ),
      body: Center(
        child: Text(
          '$number',
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementNumber,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
