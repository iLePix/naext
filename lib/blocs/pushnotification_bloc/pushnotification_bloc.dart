
import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:naext/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:naext/models/pushnotification.dart';

import '../bloc_provider.dart';


class PushNotificationBloc extends BlocBase {

  final FirebaseMessaging _firebaseMessaging;
  // stream only used when app is open
  BehaviorSubject<PushNotification<dynamic>> _incomingPushController = BehaviorSubject<PushNotification>();

  Stream<PushNotification<dynamic>> get onPushNotification => _incomingPushController;

  StreamSubscription _iosSettingsRegisteredSubscription;

  PushNotificationBloc(/*this._userService,*/ this._firebaseMessaging) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        try {
          PushNotification pushNotification = PushNotification.fromJson(message["notification"]);
          _incomingPushController.sink.add(pushNotification);
        } catch (err) {
          print(err);
        }
        //eventBus.fire(CorporateStateChanged());
        //eventBus.fire(ReloadAppointmentEvent());
      },
      onLaunch: (Map<String, dynamic> message) async {
        //eventBus.fire(CorporateStateChanged());
        //eventBus.fire(ReloadAppointmentEvent());

        PushNotification pushNotification = PushNotification.fromJson(message);
      },
      onResume: (Map<String, dynamic> message) async {
        //eventBus.fire(CorporateStateChanged());
        //eventBus.fire(ReloadAppointmentEvent());

        PushNotification pushNotification = PushNotification.fromJson(message);
      },
    );

    _iosSettingsRegisteredSubscription =
        _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
          print("Settings was changed by user : $settings");
        });
  }

  Future<void> requestPermissions() async {
    if (!Platform.isIOS) {
      // on android we not need requests permissions
      return;
    }

    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    print("Firebasemessaging-Token : " + await _firebaseMessaging.getToken());
  }

  @override
  void dispose() {
    _incomingPushController?.close();

    _iosSettingsRegisteredSubscription?.cancel();
  }
}