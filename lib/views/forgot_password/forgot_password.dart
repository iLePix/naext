import 'package:flutter/material.dart';
import 'package:naext/app_localizations.dart';
import 'package:naext/blocs/bloc_provider.dart';
import 'package:naext/blocs/forms/forgot_password_form/forgot_password_bloc.dart';
import 'package:naext/blocs/forms/forgot_password_form/forgot_password_form_validator.dart';
import 'package:naext/services/colors.dart';
import 'package:naext/views/loading/loading_view.dart';
import 'package:naext/widgets/inputs/login_input.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {


  ForgotPasswordBloc _forgotPasswordBloc = ForgotPasswordBloc();
  PageController _pageController = PageController();


  @override
  void initState() {
    _forgotPasswordBloc.sentMail.listen((DataState<bool> sent) {
      if (sent.data != null)
        if (sent.data)
          _pageController.animateToPage(
              1, duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
    });

    _forgotPasswordBloc.passwordReset.listen((DataState<bool> resetted) {
      if (resetted.data != null)
        if (resetted.data)
          Navigator.pop(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: FOREGROUND_COLOR),
        title: TText('login.changePassword', context,
          style: TextStyle(color: FOREGROUND_COLOR),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Form(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  enterEmail(),
                  enterResetToken(),
                  enterNewPassword()
                ],
              )
          ),
        ),
      ),
    );
  }

  Widget enterEmail() {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: StreamBuilder<DataState<bool>>(
          initialData: DataState.empty(),
          stream: _forgotPasswordBloc.sentMail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isLoading) {
                return LoadingView();
              }
            }
            return Column(
              children: [
                LoginInput(stream: _forgotPasswordBloc.email,
                    controller: _forgotPasswordBloc.emailTextController,
                    onChanged: _forgotPasswordBloc.emailChanged,
                    labelText: 'Email',
                    isPassword: false,
                    keyBoardType: TextInputType.emailAddress),
                FlatButton(
                  onPressed: () {
                    _forgotPasswordBloc.sendMail();
                  },
                  child: Text("Send Mail"),
                )
              ],
            );
          }
      ),
    );
  }

  void backToMailPage() {
    _pageController.animateToPage(
        0, duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
  }

  void sendMail() {
    _forgotPasswordBloc.sendMail();
  }

  Widget enterResetToken() {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: StreamBuilder<DataState<bool>>(
          initialData: DataState.empty(),
          stream: _forgotPasswordBloc.sentMail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isLoading) {
                return LoadingView();
              }
            }
            return Column(
              children: [
                LoginInput(stream: _forgotPasswordBloc.token,
                    controller: _forgotPasswordBloc.tokenTextController,
                    onChanged: _forgotPasswordBloc.tokenChanged,
                    labelText: 'Token',
                    isPassword: false,
                    keyBoardType: TextInputType.text),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlatButton(
                      onPressed: () => backToMailPage(),
                      child: Text("Resend Email"),
                    ),
                    FlatButton(
                      onPressed: () {
                        _pageController.animateToPage(
                            2, duration: Duration(milliseconds: 1),
                            curve: Curves.easeInOut);
                      },
                      child: Text("Continue"),
                    )
                  ],
                )
              ],
            );
          }
      ),
    );
  }

  Widget enterNewPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: StreamBuilder<DataState<bool>>(
          initialData: DataState.empty(),
          stream: _forgotPasswordBloc.passwordReset,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isLoading) {
                return LoadingView();
              }
            }
            return Column(
              children: [
                passwordInput(),
                FlatButton(onPressed: () => _forgotPasswordBloc.resetPassword(),
                    child: Text("Password zurücksetzen"))
              ]
              ,
            );
          }
      ),
    );
  }

  bool _hidePassword = true;

  Widget passwordInput() {
    return StreamBuilder(
        stream: _forgotPasswordBloc.password,
        builder: (BuildContext context,
            AsyncSnapshot snapshot) {
          return TextField(
              onChanged: _forgotPasswordBloc.passwordChanged,
              controller: _forgotPasswordBloc.passwordTextController,
              style: TextStyle(color: Colors.black),
              obscureText: _hidePassword,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () =>
                      setState(() {
                        _hidePassword = !_hidePassword;
                      }),
                  child: _hidePassword
                      ? Icon(Icons.visibility_off, color: FOREGROUND_COLOR)
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
        });
  }
}


