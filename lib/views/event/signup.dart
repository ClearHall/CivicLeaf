import 'dart:math';

import 'package:civicleaf/api/fetch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:civicleaf/model/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:civicleaf/views/event/myevents.dart';

class SignUpForEvent extends StatefulWidget {
  @override
  _SignUpForEventState createState() => _SignUpForEventState();
}

class _SignUpForEventState extends State<SignUpForEvent> {
  List<Event> _eventsNearMe = List();
  bool finishLoading = false;

  @override
  void initState() {
    _getEventsAvailable();
    super.initState();
  }

  void _getEventsAvailable() async {
    _eventsNearMe = await FetchModify().getEvents();

    String currUid = (await FirebaseAuth.instance.currentUser()).uid;
    List<Event> _events = (await FetchModify().getUsers())
        .firstWhere((element) => element.id == currUid)
        .signups;
    for (int i = _eventsNearMe.length - 1; i >= 0; i--) {
      try {
        if (_events
                .firstWhere((element) => element.id == _eventsNearMe[i].id) !=
            null) _eventsNearMe.removeAt(i);
      } catch (e) {
        if (_eventsNearMe[i].creator().id == currUid) _eventsNearMe.removeAt(i);
      }
    }
    _sortEventsByLocation();
  }

  void _sortEventsByLocation() async {
    var location = await Geolocator().getCurrentPosition();
    setState(() {
      _eventsNearMe.sort((e1, e2) => (distanceBetweenTwoPointsInKM(
                  e1.location.latitude,
                  e1.location.longitude,
                  location.latitude,
                  location.latitude) -
              (distanceBetweenTwoPointsInKM(e2.location.latitude,
                  e2.location.longitude, location.latitude, location.latitude)))
          .round());
      finishLoading = true;
    });
  }

  /// HAVERSINE FORMULA!!! YAY!
  double distanceBetweenTwoPointsInKM(lat1, lon1, lat2, lon2) {
    var R = 6371;
    var dLat = convertDegreesToRad(lat2 - lat1);
    var dLon = convertDegreesToRad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(convertDegreesToRad(lat1)) *
            cos(convertDegreesToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c;
    return d;
  }

  double convertDegreesToRad(deg) {
    return deg * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> wid = List();
    for (Event e in _eventsNearMe) {
      wid.add(EventWidget(
        e,
        optIn: true,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up for Events'),
      ),
      body: finishLoading
          ? ListView(
              children: wid,
            )
          : Align(
              alignment: Alignment.center, child: CircularProgressIndicator()),
    );
  }
}
