class User {
  User(this.id, this.user, this.email);

  final String id;
  final String user;
  final String email;

  getId() => this.id;

  getUser() => this.user;

  getEmail() => this.email;

}