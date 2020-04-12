import 'package:flutter/material.dart';
import 'package:quickvolunteer/views/login.dart';
import 'package:quickvolunteer/views/map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/" : (context) => LoginScreen(),
        "/mainMap" : (context) => MainMap()
      },
    );
  }
}