

class TokenDTO {


  final String accessToken;
  final String refreshToken;
  final DateTime expiry;


  List<Object> get props => [accessToken, refreshToken, expiry];
  TokenDTO(this.accessToken, this.refreshToken, this.expiry);

  TokenDTO.fromJson(Map<String, dynamic> json) :

        accessToken = json['accessToken'],
        refreshToken = json['refreshToken'],
        expiry = DateTime.fromMicrosecondsSinceEpoch(json['accessToken_expiry']);

  Map<String, dynamic> toJson() => {
    'accessToken' : accessToken,
    'refreshToken' : refreshToken,
    'accessToken_expiry' : expiry.millisecondsSinceEpoch,
  };


}