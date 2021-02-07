import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:naext/blocs/bloc_provider.dart';
import 'package:naext/blocs/pushnotification_bloc/pushnotification_bloc.dart';
import 'package:naext/models/pushnotification.dart';
import 'package:naext/services/colors.dart';

class AuthenticatedApplication extends StatefulWidget {

  final Widget child;

  const AuthenticatedApplication({Key key, this.child}) : super(key: key);

  @override
  _AuthenticatedApplicationState createState() => _AuthenticatedApplicationState();
}

class _AuthenticatedApplicationState extends State<AuthenticatedApplication> {

  PushNotificationBloc _pushNotificationBloc;

  @override
  void initState() {
    super.initState();
    _pushNotificationBloc = BlocProvider.of<PushNotificationBloc>(context);
    _pushNotificationBloc.requestPermissions();
    _pushNotificationBloc.onPushNotification.listen(_incomingPushNotification);
  }

  void _incomingPushNotification(PushNotification pushNotification) {
    if (pushNotification.title != null && pushNotification.body != null) {
      Flushbar(
        title: pushNotification.title,
        message: pushNotification.body,
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.white,
        boxShadows: [BoxShadow(
          color: Colors.grey[500],
          offset: Offset(0.1, 2.0),
          blurRadius: 20.0,
        )],
        isDismissible: true,
        duration: Duration(seconds: 5),
        titleText: Text(
          "PUSHNOTIFICATION", //TODO : WHEN friendrequest
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: FOREGROUND_COLOR, fontFamily: "ShadowsIntoLightTwo"),
        ),
        messageText: Text(
          pushNotification.body,
          style: TextStyle(fontSize: 18.0, color: Colors.black, fontFamily: "ShadowsIntoLightTwo"),
        ),
      )..show(context);
    }
  }

  @override
  void dispose() {

    _pushNotificationBloc?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}