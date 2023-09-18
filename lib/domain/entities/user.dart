class User {
  final String email;
  final String firstName;
  final String firstSurname;
  final int id;
  final Map<String, Map<String, List<String>>> permissions;
  final int role;
  final String secondName;
  final String secondSurname;
  final String token;

  User({
    required this.email,
    required this.firstName,
    required this.firstSurname,
    required this.id,
    required this.permissions,
    required this.role,
    required this.secondName,
    required this.secondSurname,
    required this.token,
  });

  String get fullName {
    return '$firstName $secondName $firstSurname $secondSurname';
  }
}
