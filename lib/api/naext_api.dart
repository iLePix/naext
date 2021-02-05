import 'package:naext/api/token_dto.dart';
import 'package:naext/models/version.dart';


class NaextApi {


  static final NaextApi _instance = NaextApi._internal();
  factory NaextApi() => _instance;

  NaextApi._internal();

  static const int REFRESH_BUFFER_MILLIS = 1000 * 10;

  static const int _I_AM_A_TEAPOT = 418, UNAUTHORIZED = 401, BANDWIDTH_LIMIT_EXCEEDED = 509;

  final String baseUrl = "https://api.naext.app";


  Function(TokenDTO) tokenUpdate;
  Function() tokenDelete;


  String _accessToken, _refreshToken;
  DateTime _accessTokenExpiry;

  void setTokens(TokenDTO tokenDTO) {
    _accessToken = tokenDTO.accessToken;
    _refreshToken = tokenDTO.refreshToken;
    _accessTokenExpiry = tokenDTO.expiry;
  }



  Future<void> usersDeleteAccount(String password) {}
  Future<void> authLogout() {}
  Future<Version> appRequiredVersion() {}
  Future<void> authResetPassword() {}

  authRequestPasswordReset(String email) {}

  Future<bool> authUsernameAvailable(String username) {}

  Future<bool> authEmailAvailable(String email) {}
}