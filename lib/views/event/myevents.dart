import 'package:civicleaf/api/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:civicleaf/model/user.dart';
import 'package:civicleaf/views/extras/HuntyDialog.dart';
import 'package:civicleaf/api/fetch.dart';
import 'package:url_launcher/url_launcher.dart';

class MyEvents extends StatefulWidget {
  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  List<Event> events;
  bool loaded = false;

  List<Widget> widgets = List<Widget>();

  @override
  void initState() {
    _getEventsAvailable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<EventWidget> wid = [];
    if (loaded)
      for (Event e in events)
        wid.add(EventWidget(
          e,
          onDelete: () {
            setState(() {
              events.remove(e);
            });
          },
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
      ),
      body: !loaded
          ? Align(
              alignment: Alignment.center, child: CircularProgressIndicator())
          : ListView(
              children: wid,
            ),
    );
  }

  void _getEventsAvailable() async {
    User user = User.fromFirestore(await Api('users')
        .getDocumentById((await FirebaseAuth.instance.currentUser()).uid));
    await user.getSignUps();
    setState(() {
      events = user.signups;
      loaded = true;
    });
  }
}

class EventWidget extends StatefulWidget {
  final Event event;
  bool optIn;
  Function onDelete;
  EventWidget(this.event, {this.optIn = false, this.onDelete});
  @override
  _EventWidget createState() =>
      _EventWidget(event, optIn: optIn, onDelete: onDelete);
}

class _EventWidget extends State<EventWidget> {
  final Event event;
  bool optIn;
  bool wait;
  Function onDelete;

  static Future<void> openMap(
      double latitude, double longitude, BuildContext c) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      showDialog(
          context: c,
          builder: (con) => HuntyDialog(
              title: 'Uh OH',
              description:
                  'You do not have google maps installed. We could not route you to your destination.',
              buttonText: 'Ok'));
    }
  }

  @override
  void initState() {
    _waitForGettingUserID();
    super.initState();
  }

  _waitForGettingUserID() async {
    wait =
        event.creator().id == (await FirebaseAuth.instance.currentUser()).uid;
    setState(() {});
  }

  _EventWidget(this.event, {this.optIn = false, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              new BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 20.0,
                  spreadRadius: 0,
                  offset: Offset(5, 5)),
            ]),
        padding: EdgeInsets.all(20),
        child: Container(
            child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      event.name,
                      style: TextStyle(fontSize: 20),
                    )),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      event.description,
                      style: TextStyle(fontSize: 12),
                    )),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(7),
                        child: Row(children: <Widget>[
                          Icon(Icons.event),
                          Text(
                              "${event.start.toDate().month}/${event.start.toDate().day}/${event.start.toDate().year} - ${event.end.toDate().month}/${event.end.toDate().day}/${event.end.toDate().year}")
                        ]),
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      openMap(event.location.latitude, event.location.longitude,
                          context);
                    },
                    child: Container(
                      child: Text('Route me there!'),
                    )),
                wait == null
                    ? CircularProgressIndicator()
                    : wait
                        ? RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                delEvent();
                                onDelete();
                              });
                            },
                            child: Container(
                              child: Text('Delete Event'),
                            ))
                        : (optIn
                            ? RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.green,
                                onPressed: () {
                                  setState(() {
                                    opt(optIn);
                                    optIn = !optIn;
                                  });
                                },
                                child: Container(
                                  child: Text('Opt In'),
                                ))
                            : RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    opt(optIn);
                                    optIn = !optIn;
                                  });
                                },
                                child: Container(
                                  child: Text('Opt Out'),
                                )))
              ],
            ),
          ),
        )));
  }

  Future<void> delEvent() async {
    await FetchModify()
        .events
        .getCollectionReference()
        .document(event.id)
        .delete();
  }

  Future<void> opt(bool optin) async {
    var a = FetchModify()
        .users
        .getCollectionReference()
        .document((await FirebaseAuth.instance.currentUser()).uid);
    var events = FetchModify().events.getCollectionReference();
    User curr;
    await a.get().then((value) => curr = User.fromFirestore(value));
    await curr.getSignUps();
    List<DocumentReference> eventRef = List();
    for (var e in curr.signups) eventRef.add(events.document(e.id));
    if (optin)
      eventRef.add(events.document(event.id));
    else
      eventRef.removeWhere((element) => element.documentID == event.id);
    Map<String, dynamic> data = {
      "name": curr.name,
      "interests": curr.interests,
      "signups": eventRef
    };
    a.updateData(data);
  }
}
