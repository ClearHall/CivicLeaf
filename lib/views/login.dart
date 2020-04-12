import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                TextFormField(
                  controller: emailController,
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
                    onPressed: () async {
                      try {
                        AuthResult result = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                      } catch (e) {
                        if (e.code == "ERROR_USER_NOT_FOUND") {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                        }
                      }
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