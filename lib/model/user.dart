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
      interests: data['interests'].cast<String>(),
      signups: data['signups']
          .map((event) => Event(
                c: event['creator'],
                description: event['description'],
                location: event['location'],
                start: event['start'],
                end: event['end'],
              ))
          .toList().cast<Event>(),
    );
  }

  @override
  String toString() {
    return 'User{name: $name, signups: $signups, interests: $interests, id: $id}';
  }
}

class Event {
  User creator;
  String name;
  String description;
  Timestamp start;
  Timestamp end;
  GeoPoint location;
  String id;

  Event({this.name, this.description, this.start, this.end, this.location, DocumentReference c}){
    c.get().then((value) => creator = User.fromFirestore(value));
  }

  Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    id = doc.documentID;
    Event(
      name: data['name'],
      description: data['description'],
      location: data['location'],
      start: data['start'],
      end: data['end'],
      c: data['creator']
    );
  }

  @override
  String toString() {
    return 'Event{creator: $creator, name: $name, description: $description, start: $start, end: $end, location: $location, id: $id}';
  }
}
