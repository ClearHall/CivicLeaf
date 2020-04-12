import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  List<Event> signups;
  List<String> interests;
  String id;

  List<DocumentReference> _sUp;

  User({this.name, this.interests, this.signups});

  User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    id = doc.documentID;
    name = data['name'];
    interests = data['interests'].cast<String>();
    _sUp = data['signups'].cast<DocumentReference>();
  }

  Future<void> getSignUps() async{
    List<Event> eventList = List();
    for(DocumentReference ref in _sUp){
      DocumentSnapshot s = await ref.get();
      Event e = Event.fromFirestore(s);
      await e.getCreator();
      eventList.add(e);
    }
    signups = eventList;
  }

  @override
  String toString() {
    return 'User{name: $name, signups: $signups, interests: $interests, id: $id}';
  }
}

class Event {
  User _creator;
  String name;
  String description;
  Timestamp start;
  Timestamp end;
  GeoPoint location;
  String id;

  Future<DocumentSnapshot> c;

  Event({this.name, this.description, this.start, this.end, this.location});
  fromDocSnap(Future<DocumentSnapshot> c) async {
    this.c = c;
  }

  Future<User> getCreator() async {
    if (_creator == null) {
      _creator = await c.then((value) => User.fromFirestore(value));
    }
    return _creator;
  }

  User creator() {
    return _creator;
  }

  Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    id = doc.documentID;
    name = data['name'];
    description = data['description'];
    location = data['location'];
    start = data['start'];
    end = data['end'];
    fromDocSnap(data['creator'].get());
  }

  @override
  String toString() {
    return 'Event{name: $name, description: $description, start: $start, end: $end, location: $location, id: $id}';
  }
}
