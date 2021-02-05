import 'package:flutter/material.dart';
import 'package:naext/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:naext/blocs/bloc_provider.dart';
import 'package:naext/views/forgot_password/forgot_password.dart';
import 'package:naext/views/authenticated_application/authenticated_application.dart';
import 'package:naext/views/main/main_view.dart';
import 'package:naext/views/unauthicated_application/unauthenticated_application.dart';

import 'package:naext/views/loading/loading_view.dart';



class ApplicationNavigator extends StatefulWidget {

  @override
  _ApplicationNavigatorStatePage createState() => _ApplicationNavigatorStatePage();
}

class _ApplicationNavigatorStatePage extends State<ApplicationNavigator> {

  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _authenticationBloc.initAuthenticationBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: StreamBuilder<AuthenticationState>(
        stream: _authenticationBloc.authenticationState,
        initialData: _authenticationBloc.currentAuthenticationState,
        builder: (BuildContext context, AsyncSnapshot<AuthenticationState> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.passwordReset) {
              return ForgotPasswordView();
            } else if (snapshot.data.authenticated) {
              return AuthenticatedApplication(child: MainView());
            } else if (!snapshot.data.authenticated){
              return UnauthenticatedApplication();
            }
          }
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: LoadingView(),
            ),
          );
        },
      ),
    );
  }


}
