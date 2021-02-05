import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:naext/blocs/forms/login_form/login_form_validator.dart';

class LoginFormValidatorBloc extends Object with LoginFormValidator {
  final _usernameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get usernameChanged => _usernameController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  Stream<String> get phone => _usernameController.stream.transform(usernameValidator);
  Stream<String> get password => _passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitCheck => Rx.combineLatest2(phone, password, (u,p) => true);

  void dispose() {
    _usernameController?.close();
    _passwordController?.close();
  }

}