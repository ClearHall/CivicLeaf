import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:civicleaf/views/extras/HuntyDialog.dart';
import 'package:geocoder/geocoder.dart';
import 'package:civicleaf/api/fetch.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController eventNameController = new TextEditingController();
  TextEditingController eventDescController = new TextEditingController();
  TextEditingController adressControllerr = new TextEditingController();

  DateTime selectedStartDate = DateTime.now();

  Future<Null> _selectStartDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2101));
    TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay(hour: picked.hour, minute: picked.minute),);
    picked.add(Duration(hours: t.hour, minutes: t.minute));
    if (picked != null && picked != selectedStartDate)
      setState(() {
        selectedStartDate = picked;
      });
  }

  DateTime selectedEndDate = DateTime.now();

  Future<Null> _selectEndDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2101));
    TimeOfDay t = await showTimePicker(context: context, initialTime: TimeOfDay(hour: picked.hour, minute: picked.minute),);
    picked.add(Duration(hours: t.hour, minutes: t.minute));
    if (picked != null && picked != selectedEndDate)
      setState(() {
        selectedEndDate = picked;
      });
  }

  _createEvent(BuildContext context) async {
    if (eventDescController.text.length < 10000 &&
        eventNameController.text.length < 100 &&
        adressControllerr.text.length < 1000) {
      var addresses =
          await Geocoder.local.findAddressesFromQuery(adressControllerr.text);
      if (addresses.length >= 1) {
        var first = addresses.first;
        if (selectedEndDate.isAfter(selectedStartDate)) {
          FetchModify().events.getCollectionReference().document().setData({
            "name": eventNameController.text,
            "description": eventDescController.text,
            "location": GeoPoint(
                first.coordinates.latitude, first.coordinates.longitude),
            "start": Timestamp.fromDate(selectedStartDate),
            "end": Timestamp.fromDate(selectedEndDate),
            "creator": FetchModify()
                .users
                .getCollectionReference()
                .document((await FirebaseAuth.instance.currentUser()).uid)
          });
            _showError(context, 'SUCCESS!');
        } else {
          _showError(context, 'Your end date must be after your start date!');
        }
      } else {
        _showError(context, 'Your adress is invalid.');
      }
    } else {
      _showError(context, 'Your description, title, or adress is too long.');
    }
  }

  _showError(BuildContext c, String mess) {
    showDialog(
        context: context,
        builder: (c) =>
            HuntyDialog(title: 'Alert!', description: mess, buttonText: 'Ok'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: eventNameController,
                decoration: InputDecoration(
                    labelText: "   Event Name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: eventDescController,
                maxLines: 10,
                decoration: InputDecoration(
                    labelText: "   Description",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: adressControllerr,
                decoration: InputDecoration(
                    labelText: "   Adress",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text('Choose start date.'),
                onPressed: () {
                  _selectStartDate(context);
                },
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text('Choose end date.'),
                onPressed: () {
                  _selectEndDate(context);
                },
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text('Create Event.'),
                onPressed: () {
                  _createEvent(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
