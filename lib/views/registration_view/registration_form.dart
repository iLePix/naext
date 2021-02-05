import 'package:flutter/material.dart';
import 'package:naext/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:naext/blocs/bloc_provider.dart';
import 'package:naext/blocs/forms/registration_form/registration_bloc.dart';
import 'package:naext/services//colors.dart';
import 'package:naext/views/loading/loading_view.dart';

import 'package:naext/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:naext/widgets/error_handler/error_handler.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  RegistrationBloc _registrationBloc;
  AuthenticationBloc _authenticationBloc;
  FocusNode _passwordFocusNode = FocusNode();


  bool _hidePassword = true;
  List<Widget> inputs;
  Size screenSize;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _registrationBloc = RegistrationBloc();

    inputs = [
      _usernameInput(),
      _emailInput(),
      _passwordInput(),
      _agreementCheck()
    ];
  }

  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return StreamBuilder<RegistrationState>(
        initialData: RegistrationState(loading: false),
        stream: _registrationBloc.loading,
        builder: (BuildContext context, AsyncSnapshot<RegistrationState> snapshot) {
          bool isLoading = snapshot.data?.loading;
          bool isSignedUp = snapshot.data?.signedUp;
          bool hasError = snapshot.data?.hasError;

          if (isLoading) {
            if (isSignedUp) {
              _authenticationBloc.authenticate();
            }
            return LoadingView();
          }

          if (hasError) {
            return Padding(
                padding: EdgeInsets.only(top: 30),
                child: ErrorHandler(snapshot.data.errorObject));
          }

          return Form(
              key: _registrationBloc.formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: screenSize.height*0.03, horizontal: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: screenSize.height*0.45,
                      child: Column(
                        children: [
                          _usernameInput(),
                          _emailInput(),
                          _passwordInput(),
                        ],
                      ),
                    ),
                    _agreementCheck(),
                    _submitButton(_registrationBloc),
                    backToLoginButton(),
                  ],
                ),
              ));
        });
  }

  Widget backToLoginButton() {
    return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenSize.height*0.1),
          child: GestureDetector(
            onTap: () => _toLogin(),
            child: Text(
              "Zurück zum Login",
              style: TextStyle(
                  color: FOREGROUND_COLOR,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ));
  }

  _toLogin() async {
    Navigator.of(context).pushReplacementNamed("startPage/login");
  }

  Widget _submitButton(RegistrationBloc registrationBloc) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: StreamBuilder<bool>(
          stream: registrationBloc.submitCheck,
          builder: (context, snapshot) => Padding(
              padding: EdgeInsets.only(top: 20),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () => snapshot.hasData ? _submit() : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          height: 50,
                          decoration: snapshot.hasData
                              ? BoxDecoration(
                            color: FOREGROUND_COLOR,
                          )
                              : BoxDecoration(
                            color: FOREGROUND_COLOR.withOpacity(0.3),
                          ),
                          child: Center(
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  )))),
    );
  }



  Widget _usernameInput() {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: StreamBuilder<AvailableCheckState>(
          stream: _registrationBloc.usernameAvailableCheck,
          initialData: AvailableCheckState(),
          builder: (BuildContext context,
              AsyncSnapshot<AvailableCheckState> snapshot) {
            return TextField(
                onChanged: _registrationBloc.usernameChanged, //_obscureText,
                controller: _registrationBloc.usernameController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon:
                  snapshot.hasData ? _availableCheck(snapshot.data) : null,
                  //widget.isPassword ? hidePasswordSuffix() : null,
                  labelText: 'Username',
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

  Widget _emailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: StreamBuilder<AvailableCheckState>(
          stream: _registrationBloc.emailAvailableCheck,
          initialData: AvailableCheckState(),
          builder: (BuildContext context,
              AsyncSnapshot<AvailableCheckState> snapshot) {
            return TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: _registrationBloc.emailChanged, //_obscureText,
                controller: _registrationBloc.emailController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon:
                  snapshot.hasData ? _availableCheck(snapshot.data) : null,
                  //widget.isPassword ? hidePasswordSuffix() : null,
                  labelText: 'Email',
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


  Widget _passwordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: StreamBuilder<AvailableCheckState>(
          stream: _registrationBloc.passwordAvailableCheck,
          initialData: AvailableCheckState(),
          builder: (BuildContext context,
              AsyncSnapshot<AvailableCheckState> snapshot) {
            return TextField(
                onChanged: _registrationBloc.passwordChanged,
                controller: _registrationBloc.passwordController,
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

  Widget _agreementCheck() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: StreamBuilder<bool>(
          stream: _registrationBloc.agreed,
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: FOREGROUND_COLOR,
                      value: snapshot.hasData ? snapshot.data : false,
                      onChanged: _registrationBloc.agree,
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: (context) => Container())),
                        child: RichText(
                          maxLines: 5,
                          overflow: TextOverflow.clip,
                          text: TextSpan(
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15),
                              children: [
                                TextSpan(text: "By using YourEco, you accept our "),
                                TextSpan(text: "Privacy Policy ", style: TextStyle(color: FOREGROUND_COLOR, fontWeight: FontWeight.w800)),
                                TextSpan(text: "as well as the "),
                                TextSpan(text: "General terms and conditions", style: TextStyle(color: FOREGROUND_COLOR, fontWeight: FontWeight.w800)),

                              ]
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                snapshot.hasError ? Text(snapshot.error, style: TextStyle(color: Colors.red),): Container(),
              ],
            );
          }),
    );
  }


  Widget _availableCheck(AvailableCheckState availableCheckState) {
    if (availableCheckState.loading)
      return _loadingIcon();
    else if (availableCheckState.available)
      return _availableIcon();
    else if (availableCheckState.unavailable) return _unavaiableIcon();
    return null;
  }

  Widget _availableIcon() => Icon(
    Icons.check,
    color: Colors.green,
  );

  Widget _unavaiableIcon() => Icon(
    Icons.close,
    color: Colors.red,
  ); //TODO : DELETE USERNAME ONCLICKED
  Widget _loadingIcon() => Padding(
      padding: EdgeInsets.all(10),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withOpacity(0.4)),
        strokeWidth: 3,
      ));


  _submit() async {
    _registrationBloc.register();
  }

  @override
  void dispose() {
    _passwordFocusNode?.dispose();
    super.dispose();
  }
}