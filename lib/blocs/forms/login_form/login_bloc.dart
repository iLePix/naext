import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:naext/api/naext_api.dart';
import 'package:naext/blocs/bloc_base.dart';
import 'package:naext/blocs/forms/login_form/login_form_validator.dart';


class LoginBloc extends BlocBase with LoginFormValidator {

  final NaextApi _naextApi = new NaextApi();

  final BehaviorSubject<LoginState> _loginStateController = BehaviorSubject<LoginState>();
  final TextEditingController usernameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final _usernameValidatorController = BehaviorSubject<String>();
  final _passwordValidatorController = BehaviorSubject<String>();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Stream<LoginState> get loginState => _loginStateController;

  Function(String) get usernameChanged => _usernameValidatorController.sink.add;
  Function(String) get passwordChanged => _passwordValidatorController.sink.add;

  Stream<String> get username => _usernameValidatorController.stream.transform(usernameValidator);
  Stream<String> get password => _passwordValidatorController.stream.transform(passwordValidator);

  Future<void> login() async {
    if (!formKey.currentState.validate()) {
      return;
    }
    _loginStateController.sink.add(LoginState(loading: true));
    /*try {
      await _naextApi.authLogin(new LoginRequest(
          fcmToken: await FirebaseMessaging().getToken(),
          username: usernameTextController.text,
          password: passwordTextController.text));
      _loginStateController.sink.add(LoginState.loggedIn());
      return;
    } on YourEcoException catch (err) {
      switch (err.statusCode) {
        case YourEcoStatusCode.INVALID_CREDENTIALS:
          _loginStateController.sink.add(LoginState.error(error: err));
          _usernameValidatorController.sink.addError("Invalid Credentials");
          _passwordValidatorController.sink.addError("Invalid Credentials");
          usernameTextController.clear();
          passwordTextController.clear();
      }
    } catch(err) {
      _loginStateController.sink.add(LoginState.error(error: err));
    }*/
  }


  Stream<bool> get submitCheck => Rx.combineLatest2(username, password, (u,p) => true);

  @override
  void dispose() {
    _loginStateController?.close();
    _usernameValidatorController?.close();
    _passwordValidatorController?.close();
    usernameTextController?.dispose();
    passwordTextController?.dispose();
  }

}

class LoginState {
  final bool loading;
  final bool loggedIn;
  final bool hasError;
  final Object errorObject;

  LoginState({this.loading = false, this.loggedIn = false, this.hasError = false, this.errorObject});

  factory LoginState.loading() {
    return LoginState(loading: true);
  }

  factory LoginState.error({Object error}) {
    return LoginState(hasError: true, errorObject: error);
  }

  factory LoginState.loggedIn() {
    return LoginState(loggedIn: true);
  }


}

enum LoginException {
  INVALID_CREDENTIALS,
  CONNECTION_FAILURE
}