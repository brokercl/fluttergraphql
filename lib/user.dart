class User {
  User(this.id, this.name, this.email, this.password);

  final String id;
  final String name;
  final String email;
  final String password;

  getId() => this.id;
  getName() => this.name;
  getEmail() => this.email;
  getPassword() => this.password;
}