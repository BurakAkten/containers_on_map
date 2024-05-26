class User {
  String? username;
  String? password;

  User({this.username, this.password});

  static User fromJson(Map<String, dynamic>? json) {
    if (json == null) return User();
    return User()
      ..username = json['username']
      ..password = json['password'];
  }

  static List<User> listFromJson(List<dynamic>? json) {
    return json == null ? <User>[] : json.map((value) => User.fromJson(value)).toList();
  }

  static List<User> get users => [
        User(username: "burak12", password: "123456"),
        User(username: "akten", password: "654321"),
      ];
}
