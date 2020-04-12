import 'dart:async';

import 'package:civicleaf/api/fetch.dart';
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
    getCurrentLocation();
    super.initState();
  }

  getCurrentLocation() async {
    _events = await FetchModify().getEvents();
    var loc = await Geolocator().getCurrentPosition();
    setState(() {
      _currentPostition = CameraPosition(
          target: LatLng(loc.latitude, loc.longitude), zoom: 6.4746);
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
            DrawerSection(Icons.assignment, 'Sign Up For Events', () {
              Navigator.of(context).pushNamed('/signupEvent');
            }),
            DrawerSection(Icons.create, 'Create Events', () {}),
            DrawerSection(Icons.grade, 'Events I\'m Hosting', () {}),
            DrawerSection(Icons.calendar_today, 'My Calendar', () {}),
            DrawerSection(Icons.arrow_back, 'Logout', () {
              Navigator.of(context).popUntil((route) => route.settings.name == '/');
            })
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
