import 'dart:ffi';

import 'package:flutter/material.dart';
//Biblioteca para armazenamento local usando padrão do SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TemaShared(title: 'Flutter Demo Home Page'),
    );
  }
}

class TemaShared extends StatefulWidget {
  const TemaShared({super.key, required this.title});
  final String title;

  @override
  State<TemaShared> createState() => _TemaSharedState();
}

class _TemaSharedState extends State<TemaShared> {
  bool temaClaro = true;

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Switch(
                value: temaClaro,
                activeColor: Colors.red,
                onChanged: (bool value) {
                  setState(() {
                    temaClaro = value;
                  });
                }),
            const Text("Tema: ")
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
