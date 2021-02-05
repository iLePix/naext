import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:naext/api/naext_api.dart';
import 'package:naext/blocs/bloc_base.dart';

class RegistrationBloc extends BlocBase {


  final NaextApi _yourEcoApi = NaextApi();


  final BehaviorSubject<RegistrationState> _loadingController = BehaviorSubject<RegistrationState>();
  final BehaviorSubject<bool> _agreementController = BehaviorSubject<bool>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final BehaviorSubject<AvailableCheckState> _usernameAvailableController = BehaviorSubject<AvailableCheckState>();
  final BehaviorSubject<AvailableCheckState> _emailAvailableController = BehaviorSubject<AvailableCheckState>();
  final BehaviorSubject<AvailableCheckState> _passwordAvailableController = BehaviorSubject<AvailableCheckState>();

  Stream<RegistrationState> get loading => _loadingController;

  Stream<AvailableCheckState> get usernameAvailableCheck => _usernameAvailableController.stream;
  Stream<AvailableCheckState> get emailAvailableCheck => _emailAvailableController.stream;
  Stream<AvailableCheckState> get passwordAvailableCheck => _passwordAvailableController.stream;

  Stream<bool> get agreed => _agreementController.stream;
  Function(bool) get agree => _agreementController.sink.add;

  usernameChanged(String username) async {

    if(username.length <= 3) {
      _usernameAvailableController.sink.add(AvailableCheckState(unavailable: true));
      _usernameAvailableController.addError('Username is too short');
    } else {
      _usernameAvailableController.sink.add(AvailableCheckState(loading: true));
      _yourEcoApi.authUsernameAvailable(username).then((isAvailable) {
        if (isAvailable) {
          _usernameAvailableController.sink.add(AvailableCheckState(available: true));
        }
        else {
          _usernameAvailableController.sink.add(AvailableCheckState(unavailable: true));
          _usernameAvailableController.addError('Username is already taken');
        }
      });
    }
  }

  emailChanged(String email) async {

    if(!email.contains("@") && !email.contains(".")) {
      _emailAvailableController.sink.add(AvailableCheckState(unavailable: true));
      _emailAvailableController.addError('This is not an email');
    } else {
      _emailAvailableController.sink.add(AvailableCheckState(loading: true));
      _yourEcoApi.authEmailAvailable(email).then((isAvailable) {
        if (isAvailable) {
          _emailAvailableController.sink.add(AvailableCheckState(available: true));
        }
        else if (!isAvailable) {
          _emailAvailableController.sink.add(AvailableCheckState(unavailable: true));
          _emailAvailableController.addError('Email is already registered');
        }
      });
    }
  }

  passwordChanged(String password) {
    if(password.length <= 6) {
      _passwordAvailableController.addError('Password too short');
    } else {
      _passwordAvailableController.sink.add(AvailableCheckState(available: true));
    }
  }

  Stream<bool> get submitCheck => Rx.combineLatest4(usernameAvailableCheck, emailAvailableCheck, passwordAvailableCheck,agreed, (u,e,p,a) => true);



  Future<void> register() async {
    if (!formKey.currentState.validate()) {
      return;
    }

    if (!(_agreementController.value ?? false)) {
      _agreementController.sink.addError("Not agreed");
      return;
    }
    _loadingController.sink.add(RegistrationState(loading: true));
    /*try {
      await _yourEcoApi.authSignup(new SignupRequest(
          password: passwordController.text,
          email: emailController.text,
          username: usernameController.text,
          fcmToken: await FirebaseMessaging().getToken()));
      _loadingController.sink.add(RegistrationState.signedUp());
    } on YourEcoException catch (err) {
      switch(err.statusCode) {
        case YourEcoStatusCode.USERNAME_TAKEN:
          _usernameAvailableController.sink.add(AvailableCheckState(unavailable: true));
          _usernameAvailableController.addError('Username is already taken');
          break;
        case YourEcoStatusCode.EMAIL_TAKEN:
          _usernameAvailableController.sink.add(AvailableCheckState(unavailable: true));
          _usernameAvailableController.addError('There is already an Account with this Email');
          break;
      }
    } catch (err) {
      print("RegistrationBloc.register Error : " + err.toString());
      _loadingController.sink.add(RegistrationState(errorObject: err));
    }*/
  }

  toggleAgreement() async {
    _agreementController.sink.add(!(_agreementController.value ?? false));
  }


  @override
  void dispose() {
    _usernameAvailableController?.close();
    _emailAvailableController?.close();
    _loadingController?.close();
    _agreementController?.close();
  }
}

class RegistrationState {
  final bool loading;
  final bool signedUp;
  final bool hasError;
  final Object errorObject;
  final int errorPage;

  RegistrationState({this.loading = false, this.signedUp = false, this.hasError = false, this.errorObject, this.errorPage = 0});


  factory RegistrationState.signedUp() {
    return RegistrationState(loading: true, signedUp: true);
  }


  factory RegistrationState.error({Object error, int errorPage}) {
    return RegistrationState(hasError: true, errorObject: error, errorPage: errorPage);
  }

  factory RegistrationState.loading() {
    return RegistrationState(loading:true);
  }


}

class AvailableCheckState {
  final bool loading;
  final bool available;
  final bool unavailable;

  AvailableCheckState({this.loading = false , this.available = false, this.unavailable = false});

}