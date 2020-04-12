import 'package:civicleaf/api/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:civicleaf/model/user.dart';
import 'package:civicleaf/views/extras/HuntyDialog.dart';
import 'package:civicleaf/api/fetch.dart';
import 'package:url_launcher/url_launcher.dart';

import 'myevents.dart';

class EventsHosting extends StatefulWidget {
  @override
  _EventsHostingState createState() => _EventsHostingState();
}

class _EventsHostingState extends State<EventsHosting> {
  List<Event> events;
  _EventsHostingState();
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
              events = null;
              loaded = false;
              _getEventsAvailable();
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
    List<Event> ev = await FetchModify().getEvents();
    for(Event e in ev) print(e.creator().id);
    String currID = (await FirebaseAuth.instance.currentUser()).uid;
    setState(() {
      try {
        events = ev.where((element) => element.creator().id == currID).toList();
      }catch(e){
        events = [];
      }
      loaded = true;
    });
  }
}
