class User {
  int userId;
  String name;
  String username;
  String email;
  String photoProfile;
  String token;
  String renewalToken;

  User({
    this.userId,
    this.name,
    this.username,
    this.email,
    this.photoProfile,
    this.token,
    this.renewalToken,
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      userId: responseData['id'],
      name: responseData['name'],
      username: responseData['username'],
      email: responseData['email'],
      photoProfile: responseData['profile_photo_path'],
      token: responseData['access_token'],
      renewalToken: responseData['renewal_token'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': userId,
        'name': name,
        'username': username,
        'email': email,
        'photoProfile': photoProfile,
        'token': token,
        'renewalToken': renewalToken,
      };

  @override
  String toString() {
    return "{'userId': $userId, 'name': $name, 'username': $username, 'email': $email, 'photoProfile': $photoProfile,'token': $token, 'renewalToken': $renewalToken}";
  }
}
