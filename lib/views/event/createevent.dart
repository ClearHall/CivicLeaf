import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  static const APIKEY = 'AIzaSyCVhLYmGAwKa7bSIgn8fkLeAwvVoCmemuU';
  TextEditingController eventNameController = new TextEditingController();
  TextEditingController eventDescController = new TextEditingController();
  Prediction p;

  _choosePlace() async{
    p = await PlacesAutocomplete.show(
        context: context,
        apiKey: APIKEY,
        mode: Mode.overlay, // Mode.fullscreen
        language: "en",
        components: [new Component(Component.country, "us")]);
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
              SizedBox(height: 20,),
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
              SizedBox(height: 20,),
              RaisedButton(onPressed: (){
                _choosePlace();
              }, child: Text('Choose a Location'),)
            ],
          ),
        ),
      ),
    );
  }
}
