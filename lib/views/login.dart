import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "   Username",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                Padding(padding: EdgeInsets.all(12.0)),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "   Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                ),
                Padding(padding: EdgeInsets.only(top: 32)),
                ButtonTheme(
                  minWidth: 175,
                  height: 50,
                  child: FlatButton(
                    color: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64)),
                    child: Text(
                      "SIGN IN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                      ),
                    ),
                    onPressed: () {
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}