class LoginRegisterRequest {
  String? email;
  String? username;
  String? firstName;
  String? lastName;
  String? password;
  String? birthDate; // yyyy-MM-dd gibi string olarak bekleniyor

  LoginRegisterRequest({
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.password,
    this.birthDate,
  });

  LoginRegisterRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    password = json['password'];
    birthDate = json['birth_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['password'] = password;
    data['birth_date'] = birthDate;
    return data;
  }
}
