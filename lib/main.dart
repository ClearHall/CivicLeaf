import 'package:flutter/material.dart';
import 'package:civicleaf/views/login.dart';
import 'package:civicleaf/views/map.dart';
import 'package:civicleaf/views/event/myevents.dart';
import 'package:civicleaf/views/event/signup.dart';
import 'package:civicleaf/views/event/createevent.dart';

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
      debugShowCheckedModeBanner: false,
      routes: {
        "/" : (context) => LoginScreen(),
        "/mainMap" : (context) => MainMap(),
        "/myEvents" : (context) => MyEvents(ModalRoute.of(context).settings.arguments),
        "/signupEvent" : (context) => SignUpForEvent(),
        "/createEvent" : (context) => CreateEvent(),
      },
    );
  }
}