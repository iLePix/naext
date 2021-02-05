
import 'package:flutter/material.dart';
import 'package:naext/services/colors.dart';
import 'package:naext/views/registration_view/registration_form.dart';




class RegistrationView extends StatefulWidget {

  State<StatefulWidget> createState() => RegistrationViewState();
}



class RegistrationViewState extends State<RegistrationView> {

  var screenSize;


  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration', style: TextStyle(color: FOREGROUND_COLOR),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: FOREGROUND_COLOR),
      ),
      backgroundColor: BACKGROUND_COLOR,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: screenSize.height,
          child: RegistrationForm(),
        ),
      ),
    );
  }
}