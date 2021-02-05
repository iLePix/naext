import 'package:flutter/material.dart';
import 'package:naext/services/colors.dart';
import 'package:naext/views/login_view/login_form.dart';

import '../../app_localizations.dart';


class StartView extends StatefulWidget {
  @override
  _StartViewState createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {

  Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            earth(),
            LoginForm(),
            registerButton()
          ],
        ),
      ),
    );
  }

  Widget earth() {
    return Container(
      child: Column(
        children: [
          TText('login.bigText', context, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget registerButton() {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: GestureDetector(
          onTap: () => _toRegistrationPage(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TText("login.new", context, style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(width: 5),
              TText("login.registerNow", context, style: TextStyle(color: FOREGROUND_COLOR, decoration: TextDecoration.underline, fontWeight: FontWeight.w600),),
            ],
          ),
        )
    );
  }

  _toRegistrationPage() async {
    Navigator.of(context).pushNamed("startPage/register");
  }


}