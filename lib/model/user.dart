import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  List<Signup> signups;
  List<String> interests;

  User({this.name, this.interests, this.signups});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return User(
        name: data['name'],
        interests: data['interests'] ,
        signups: data['signups'] ?? ''
    );
  }
}
class Event {
  String name;
  String description;
  DateTime start;
  DateTime end;
  GeoPoint location;

  Event({this.name, this.description, this.start, this.end, this.location});

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Event(
        name: data['name'],
        description: data['description'],
        location: data['interests'] ,
        start: DateTime(data['start']),
    );
  }
}
class Signup {
}