import 'package:flutter/cupertino.dart';
import 'package:naext/api/naext_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:naext/blocs/forms/forgot_password_form/forgot_password_form_validator.dart';

import 'package:naext/blocs/bloc_provider.dart';
import 'package:naext/blocs/bloc_base.dart';

class ForgotPasswordBloc extends BlocBase with ForgotPasswordFormValidator {

  NaextApi _naextApi = NaextApi();

  TextEditingController emailTextController = TextEditingController();
  TextEditingController tokenTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  BehaviorSubject<DataState<bool>> _sentMailController = BehaviorSubject<DataState<bool>>();
  BehaviorSubject<DataState<bool>> _passwordResetController = BehaviorSubject<DataState<bool>>();

  final _emailController = BehaviorSubject<String>();
  final _tokenController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get tokenChanged => _tokenController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  Stream<DataState<bool>> get sentMail => _sentMailController.stream;
  Stream<DataState<bool>> get passwordReset => _passwordResetController.stream;

  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get token => _tokenController.stream.transform(tokenValidator);
  Stream<String> get password => _passwordController.stream.transform(passwordValidator);




  Future<void> sendMail() async {
    _sentMailController.sink.add(DataState.loading());
    try {
      await _naextApi.authRequestPasswordReset(emailTextController.text).then((value) => _sentMailController.sink.add(DataState.loaded(true)));
    } catch (err) {
      print("ForgotPasswordBloc.sendMail : " + err.toString());
      _sentMailController.sink.add(DataState.error(error: err));
    }
  }


  Future<void> resetPassword() async {
    _passwordResetController.sink.add(DataState.loading());
    try {
      await _naextApi.authResetPassword().then((value) => _passwordResetController.sink.add(DataState.loaded(true)));
    } catch (err) {
      _passwordResetController.sink.add(DataState.error(error: err));
    }
  }


  @override
  void dispose() {
    _emailController?.close();
    _tokenController?.close();
    _passwordController?.close();
    _sentMailController?.close();
    _passwordResetController?.close();
  }

}