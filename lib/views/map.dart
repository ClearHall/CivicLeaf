import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainMap extends StatefulWidget {
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

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
            DrawerSection(Icons.event, 'My Events', () {}),
            DrawerSection(Icons.assignment, 'Sign Up For Events', () {}),
            DrawerSection(Icons.calendar_today, 'My Calendar', () {})
          ],
        ),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
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
