import 'package:flutter/material.dart';
import 'package:naext/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:naext/blocs/bloc_provider.dart';
import 'package:naext/blocs/forms/login_form/login_bloc.dart';
import 'package:naext/services//colors.dart';
import 'package:naext/views/forgot_password/forgot_password.dart';
import 'package:naext/widgets/inputs/login_input.dart';

import 'package:naext/blocs/authentication_bloc/authentication_bloc.dart';

class LoginForm extends StatefulWidget {

  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {

  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;
  FocusNode _passwordFocusNode = FocusNode();
  bool _hidePassword = true;


  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<LoginState>(
        initialData: LoginState(loading: false),
        stream: _loginBloc.loginState,
        builder: (BuildContext context, AsyncSnapshot<LoginState> snapshot) {
          bool isLoading = snapshot.data?.loading;
          bool isLoggedIn = snapshot.data?.loggedIn;
          //bool hasError = snapshot.data?.hasError;

          if (isLoading) {
            return Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(FOREGROUND_COLOR),
                ),
              ),
            );
          }

          if (isLoggedIn) {
            _authenticationBloc.authenticate();
          }

          return Form(
              key: _loginBloc.formKey,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    LoginInput(stream: _loginBloc.username, controller: _loginBloc.usernameTextController, onChanged: _loginBloc.usernameChanged ,labelText: 'Benutzername', isPassword: false, keyBoardType: TextInputType.emailAddress),
                    passwordInput(),
                    forgotPassword(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 70),
                      child: Column(
                        children: <Widget>[
                          submitButton(_loginBloc),
                        ],
                      ),
                    ),
                  ],
                ),
              ));


        }
    );
  }

  Widget forgotPassword() {
    return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: GestureDetector(
            onTap: () =>  _forgotPassword(),
            child:  Text("Passwort vergessen?", style: TextStyle(color: FOREGROUND_COLOR, decoration: TextDecoration.underline, fontWeight: FontWeight.w600),),
          ),
        )
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: StreamBuilder(
          stream: _loginBloc.password,
          builder: (BuildContext context,
              AsyncSnapshot snapshot) {
            return TextField(
                onChanged: _loginBloc.passwordChanged,
                controller: _loginBloc.passwordTextController,
                style: TextStyle(color: Colors.black),
                obscureText: _hidePassword,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() {
                      _hidePassword = !_hidePassword;
                    }),
                    child: _hidePassword
                        ? Icon(Icons.visibility_off,color: FOREGROUND_COLOR)
                        : Icon(
                      Icons.visibility,
                      color: FOREGROUND_COLOR,
                    ),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: FOREGROUND_COLOR),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 3.0,
                    ),
                  ),
                  errorText: snapshot.error,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                      BorderSide(width: 3.0, color: FOREGROUND_COLOR)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: BACKGROUND_COLOR,
                      width: 1.0,
                    ),
                  ),
                ));
          }),
    );
  }



  _forgotPassword() async {
    //Navigator.pushNamed(_ctx, '/forgotPassword');
    Navigator.of(context).push(
        MaterialPageRoute(fullscreenDialog: true, builder: (context) => ForgotPasswordView()));
  }


  Widget submitButton(loginFormBloc) {
    return StreamBuilder<bool>(
        stream: loginFormBloc.submitCheck,
        builder: (context, snapshot) =>
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: snapshot.hasData ? () => _submit() : null,
                          child: Container(
                            width: 300,
                            height: 50,
                            decoration: snapshot.hasData ? BoxDecoration(
                              color: FOREGROUND_COLOR,
                            ) : BoxDecoration(
                              color: FOREGROUND_COLOR.withOpacity(0.3),),
                            child: Center(
                              child: Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          )
                      ),)
                )
            )
    );
  }

  _submit() async {
    _loginBloc.login();
  }

  @override
  void dispose() {
    _passwordFocusNode?.dispose();
    super.dispose();
  }
}