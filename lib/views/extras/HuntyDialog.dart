import 'package:flutter/material.dart';

class HuntyDialog extends StatelessWidget {
  final String title, description, buttonText;

  HuntyDialog({@required this.title,
    @required this.description,
    @required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: customDialogContent(context),
    );
  }

  createDialogBoxContents(BuildContext context) {
    return <Widget>[
      Text(
        title,
        style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,),
      ),
      SizedBox(height: 16.0),
      Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.0),
      ),
      SizedBox(height: 24.0),
      Align(
        alignment: Alignment.bottomRight,
        child: FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            buttonText,
          ),
        ),
      ),
    ];
  }

  customDialogContent(BuildContext context) {
    Widget steck = Stack(
      children: <Widget>[
        Container(
          padding:
          EdgeInsets.only(top: 16.0 + 66, bottom: 16, left: 15, right: 16),
          margin: EdgeInsets.only(top: 66),
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: createDialogBoxContents(context),
          ),
        )
      ],
    );
    return steck;
  }
}