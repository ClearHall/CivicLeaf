import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  List<Event> signups;
  List<String> interests;
  String id;

  User({this.name, this.interests, this.signups});

  User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    id = doc.documentID;
    User(
        name: data['name'],
        interests: data['interests'],
        signups: data['signups'].map((event) => Event(
      creator: event['creator'],
      description: event['description'],
      location: event['location'] ,
      start: event['start'],
      end: event['end'],
    )).toList(),
    );
  }
}
class Event {
  User creator;
  String description;
  Timestamp start;
  Timestamp end;
  GeoPoint location;
  String id;

  Event({this.creator, this.description, this.start, this.end, this.location});

  Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    id = doc.documentID;
    data['creator'].get().then((snap) => creator=User.fromFirestore(snap));
    Event(
        description: data['description'],
        location: data['location'] ,
        start: data['start'],
        end: data['end'],

    );

  }
}