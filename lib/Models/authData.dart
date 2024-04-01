class AuthData {
  final int customerId;
  final String token;
  final String tokenType;

  AuthData({
    required this.customerId,
    required this.token,
    required this.tokenType,
  });

  AuthData.fromJson(Map<String, dynamic> json)
      : customerId = json['customer_id'],
        token = json['access_token'],
        tokenType = json['token_type'];
}

class SignUpData {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;

  SignUpData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
  });

  SignUpData.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'],
        lastName = json['last_name'],
        email = json['email'],
        phone = json['phone_no'],
        password = json['password'];
}
