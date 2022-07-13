class Token {
  final String access_token;
  final String token_type;

  const Token({required this.access_token, required this.token_type});

  factory Token.fromJson(Map<String, dynamic> json)
  {
    return Token(
      access_token: json['access_token'],
      token_type: json['token_type'],
    );
  }

  @override
  String toString()
  {
    return access_token;
  }
}