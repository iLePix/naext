import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:naext/blocs/forms/registration_form/registration_form_validator.dart';

class RegistrationFormValidatorBloc extends Object with RegistrationFormValidator {
  final _usernameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get usernameChanged => _usernameController.sink.add;
  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  Stream<String> get username => _usernameController.stream.transform(usernameValidator);
  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get password => _passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitCheck => Rx.combineLatest3(username, email, password, (n,u,p) => true);

  void dispose() {
    _usernameController?.close();
    _emailController?.close();
    _passwordController?.close();
  }

}
