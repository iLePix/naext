import 'package:naext/app.dart';
import 'package:naext/services/db_service.dart';
import 'package:naext/api/naext_api.dart';

import 'package:naext/api/token_dto.dart';



class TokenService {

  final NaextApi _naextApi = NaextApi();
  final DatabaseService _dbService = DatabaseService();

  static final TokenService _tokenService = TokenService._internal();

  factory TokenService() {
    return _tokenService;
  }

  TokenService._internal() {
    _naextApi.tokenUpdate = persistToken;
    _naextApi.tokenDelete = deleteToken;
  }

  Future<void> deleteToken() async {
    _dbService.deleteSession();
  }

  Future<void> persistToken(TokenDTO tokenDTO) async {
    if (tokenDTO == null) {
      throw new Exception("Token to persist can not be null");
    }
    _dbService.deleteSession();
    _dbService.saveSession(tokenDTO);
    return;
  }

  Future<bool> checkIfLoginExistsInDataBaseAndIfSoLoadTokensIntoApiWrapper() async {
    List _tokens = await _dbService.getSessionData();
    if (_tokens.length > 0) {
      TokenDTO tokenDTO = TokenDTO.fromJson(_tokens[0]);
      _naextApi.setTokens(tokenDTO);
      return true;
    }
    return false;
  }
}
