import 'package:flutter/material.dart';
import 'package:civicleaf/views/login.dart';
import 'package:civicleaf/views/map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Civic Leaf',
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