import 'package:flutter/material.dart';
import 'package:naext/views/registration_view/registration_view.dart';
import 'package:naext/views/start_view/start_view.dart';

class UnauthenticatedApplication extends StatefulWidget {
  @override
  _UnauthenticatedApplicationState createState() => _UnauthenticatedApplicationState();
}

class _UnauthenticatedApplicationState extends State<UnauthenticatedApplication> {


  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'startPage/login',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'startPage/login':
            builder = (BuildContext _) => StartView();
            break;
          case 'startPage/register':
            builder = (BuildContext _) => RegistrationView();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
