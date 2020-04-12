import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  List<Event> signups;
  List<String> interests;

  User({this.name, this.interests, this.signups});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return User(
        name: data['name'],
        interests: data['interests'],
        signups: data['signups'].map((event) => Event(
      name: event['name'],
      description: event['description'],
      location: event['location'] ,
      start: event['start'],
      end: event['end'],
    )).toList(),
    );
  }
}
class Event {
  String name;
  String description;
  Timestamp start;
  Timestamp end;
  GeoPoint location;

  Event({this.name, this.description, this.start, this.end, this.location});

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Event(
        name: data['name'],
        description: data['description'],
        location: data['location'] ,
        start: data['start'],
        end: data['end'],
    );
  }
}