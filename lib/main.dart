import 'package:flutter/material.dart';
import 'package:near_me_ui/NearMe/screens/NearMeScreen.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Near Me',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: NearMe(),
    );
  }
}

