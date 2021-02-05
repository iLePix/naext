import 'package:rxdart/rxdart.dart';
import 'package:naext/api/naext_api.dart';

import 'package:naext/services/token_service.dart';
import 'package:naext/blocs/bloc_base.dart';

class AuthenticationBloc extends BlocBase {
  final TokenService _tokenService = TokenService();
  final NaextApi _naextApi = NaextApi();

  BehaviorSubject<AuthenticationState> _authenticationStateController = BehaviorSubject<AuthenticationState>();

  Stream<AuthenticationState> get authenticationState => _authenticationStateController;

  AuthenticationState get currentAuthenticationState => _authenticationStateController.value;

  Future<void> authenticate() async {
    _authenticationStateController.sink.add(AuthenticationState.authenticated());
  }

  initAuthenticationBloc() async {
    if (await _tokenService.checkIfLoginExistsInDataBaseAndIfSoLoadTokensIntoApiWrapper()) {
      _authenticationStateController.sink.add(AuthenticationState.authenticated());
    } else {
      _authenticationStateController.sink.add(AuthenticationState.notAuthenticated());
    }
  }

  void backToLogin() => _authenticationStateController.sink.add(AuthenticationState.notAuthenticated());

  void forgotPassword() => _authenticationStateController.sink.add(AuthenticationState.resettingPassword());

  Future<void> logout() async {
    try {
      _naextApi.authLogout();
      _authenticationStateController.sink.add(AuthenticationState.notAuthenticated());
    } catch (err) {
      print(err);
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      _naextApi.usersDeleteAccount(password);
      _authenticationStateController.sink.add(AuthenticationState.notAuthenticated());
    } catch (err) {
      print(err);
    }
  }


  @override
  void dispose() {
    _authenticationStateController?.close();
  }

}





class AuthenticationState {
  final bool authenticated;
  final bool passwordReset;

  AuthenticationState({this.authenticated: false, this.passwordReset = false});

  factory AuthenticationState.init() {
    return AuthenticationState();
  }

  factory AuthenticationState.resettingPassword() {
    return AuthenticationState(passwordReset: true);
  }

  factory AuthenticationState.authenticated() {
    return AuthenticationState(authenticated: true);
  }

  factory AuthenticationState.notAuthenticated() {
    return AuthenticationState(
      authenticated: false,
    );
  }

}