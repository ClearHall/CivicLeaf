import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:civicleaf/model/user.dart';
import 'package:civicleaf/views/event/myevents.dart';

class MainMap extends StatefulWidget {
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  List<Event> _events = List();
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();

  static CameraPosition _currentPostition;

  @override
  void initState() {
    _events.add(Event(
        name: 'Memorial Park',
        description:
            'I AM A LONG DESCRIPTION SHOWING HOW LOGN I AM CAUSE I AM JUST REALLY LONG!',
        start: Timestamp.fromDate(DateTime(2020, 4, 11, 4, 20, 1)),
        end: Timestamp.fromDate(DateTime(2020, 4, 15, 4, 30, 0)),
        location: GeoPoint(20.9391, -95.3)));
    getCurrentLocation();
    super.initState();
  }

  getCurrentLocation() async {
    var loc = await Geolocator().getCurrentPosition();
    setState(() {
      _currentPostition = CameraPosition(
          target: LatLng(loc.latitude, loc.longitude), zoom: 14.4746);
      for (int i = 0; i < _events.length; i++) {
        Event e = _events[i];
        _markers.add(Marker(
            markerId: MarkerId('$i'),
            position: LatLng(e.location.latitude, e.location.longitude),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (c) => Dialog(
                          child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            EventWidget(e),
                            Align(
                              alignment: Alignment.center,
                              child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(c).pop();
                                  },
                                  child: Text('Ok')),
                            )
                          ],
                        ),
                      )));
            }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Map'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: FittedBox(
                child: Text(
                  "MEIN NAME",
                  maxLines: 10,
                ),
              ),
            ),
            DrawerSection(Icons.event, 'My Events', () {
              Navigator.of(context).pushNamed('/myEvents', arguments: _events);
            }),
            DrawerSection(Icons.assignment, 'Sign Up For Events', () {}),
            DrawerSection(Icons.create, 'Create Events', () {}),
            DrawerSection(Icons.grade, 'Events I\'m Hosting', () {}),
            DrawerSection(Icons.calendar_today, 'My Calendar', () {})
          ],
        ),
      ),
      body: _currentPostition == null
          ? Align(
              alignment: Alignment.center, child: CircularProgressIndicator())
          : GoogleMap(
              markers: _markers,
              mapType: MapType.normal,
              initialCameraPosition: _currentPostition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
    );
  }
}

class DrawerSection extends ListTile {
  final IconData icon;
  final String text;

  DrawerSection(this.icon, this.text, void Function() onTap)
      : super(
            leading: Container(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                icon,
              ),
            ),
            title: Text(
              text,
              style: TextStyle(fontSize: 25),
            ),
            onTap: onTap);
}
