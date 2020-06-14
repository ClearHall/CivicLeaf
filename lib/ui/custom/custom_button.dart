import 'package:flutter/material.dart';

class HuntyButton extends StatelessWidget {
  final Function() func;
  final Widget child;

  const HuntyButton({Key key, this.func,  this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      onPressed: func,
      child: child,
    );
  }
}
