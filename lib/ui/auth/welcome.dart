import 'package:civic_leaf/ui/setting/setting_language_actions.dart';
import 'package:flutter/material.dart';
import 'package:civic_leaf/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:civic_leaf/providers/language_provider.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const double roundedCornerRadius = 60;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(roundedCornerRadius)),
            child: Image.network(
              //TODO: Placeholder
              'https://previews.123rf.com/images/rawpixel/rawpixel1707/rawpixel170761370/82860837-helping-hands-volunteer-support-community-service-graphic.jpg',
              height: MediaQuery.of(context).size.height * .60,
              fit: BoxFit.fill,
            ),
          )),
          Container(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              AppLocalizations.of(context).translate("welcome"),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 40),
            child: Text(
              AppLocalizations.of(context).translate("welcomeDescription"),
              style: Theme.of(context).textTheme.body2,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              flex: 1,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(roundedCornerRadius))),
                onPressed: () { },
                child: Text(
                  AppLocalizations.of(context).translate("welcomeContinue"),
                ),
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
