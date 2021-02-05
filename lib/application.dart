import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:naext/views/navigator/application_navigator.dart';
import 'package:naext/blocs/pushnotification_bloc/pushnotification_bloc.dart';
import 'package:naext/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:naext/blocs/appversion_bloc/appversion_bloc.dart';
import 'package:naext/blocs/bloc_provider.dart';
import 'package:package_info/package_info.dart';
import 'package:naext/services/colors.dart';
import 'package:naext/app_localizations.dart';



class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}


class _ApplicationState extends State<Application> {

  PushNotificationBloc _pushNotificationBloc;
  AuthenticationBloc _authenticationBloc;
  AppVersionBloc _versionBloc;

  @override
  void initState() {
    super.initState();
    _pushNotificationBloc = PushNotificationBloc(FirebaseMessaging());
    _authenticationBloc = AuthenticationBloc();
    _versionBloc = AppVersionBloc();
    _versionBloc.checkForNewVersion();
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        initialData: false,
        stream: _versionBloc.requiresUpdate,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return requiresUpdate();
            }
          }
          return BlocProvider<PushNotificationBloc>(
            bloc: _pushNotificationBloc,
            child: BlocProvider<AuthenticationBloc>(
              bloc: _authenticationBloc,
              child: ApplicationNavigator(),
            ),
          );
        }
    );
  }


  Widget requiresUpdate() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.keyboard_arrow_down, size: 40, color: FOREGROUND_COLOR),
                TText("app.updateRequired", context, style: TextStyle(fontSize: 20, color: FOREGROUND_COLOR,fontWeight: FontWeight.w800)),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: FutureBuilder<String>(
                      future: PackageInfo.fromPlatform().then((value) => value.version),
                      initialData: "[Loading]",
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(Lang.get(context, "app.currentVersion") + ": " + snapshot.data, style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center,);
                        }
                        return Center(
                            child: CircularProgressIndicator());
                      },
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}
