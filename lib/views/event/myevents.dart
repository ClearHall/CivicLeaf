import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:civicleaf/model/user.dart';

class MyEvents extends StatefulWidget {
  final List<Event> events;

  MyEvents(this.events);

  @override
  _MyEventsState createState() => _MyEventsState(events);
}

class _MyEventsState extends State<MyEvents> {
  final List<Event> events;
  _MyEventsState(this.events);

  List<Widget> widgets = List<Widget>();

  @override
  Widget build(BuildContext context) {
    List<EventWidget> wid = [];
    for (Event e in events) wid.add(EventWidget(e));

    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
      ),
      body: ListView(
        children: wid,
      ),
    );
  }
}

class EventWidget extends Container {
  final Event event;
  final bool optIn;

  EventWidget(this.event, {this.optIn = false})
      : super(
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
                          //TODO: ADD OPT INTO EVENT
                        },
                        child: Container(
                          child: Text('Route me there!'),
                        )),
                    optIn ? RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.green,
                        onPressed: () {
                          //TODO: ADD OPT INTO EVENT
                        },
                        child: Container(
                          child: Text('Opt In'),
                        )) : RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.red,
                        onPressed: () {
                          //TODO: ADD OPT OUT OF EVENT
                        },
                        child: Container(
                          child: Text('Opt Out'),
                        ))
                  ],
                ),
              ),
            )));
}
