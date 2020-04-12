import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:civicleaf/views/extras/HuntyDialog.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
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
                Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Welcome',
                      style: TextStyle(fontSize: 30),
                    )),
                TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "   Email",
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
                  controller: passwordController,
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonTheme(
                        minWidth: 140,
                        height: 50,
                        child: FlatButton(
                          color: Colors.tealAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(64)),
                          child: Text(
                            "SIGNUP",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text);
                              Navigator.of(context).pushNamed('/mainMap');
                            } on PlatformException catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (c) => HuntyDialog(
                                        buttonText: 'Ok',
                                        title: 'Uh Oh!',
                                        description: e.message,
                                      ));
                            }
                          },
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 140,
                        height: 50,
                        child: FlatButton(
                          color: Colors.tealAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(64)),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailController.text.trim(),
                                      password: passwordController.text);
                              Navigator.of(context).pushNamed('/mainMap');
                            } catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (c) => HuntyDialog(
                                        buttonText: 'Ok',
                                        title: 'Uh Oh!',
                                        description: e.message,
                                      ));
                            }
                          },
                        ),
                      )
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
