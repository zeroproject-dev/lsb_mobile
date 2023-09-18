import 'package:lsb_translator/domain/entities/user.dart';
// class UserMapper {
//   static User userJsonToEntity(Map<String, dynamic> json) {
//     print(json);
//
//     return User(
//       email: json['email'],
//       firstName: json['first_name'],
//       firstSurname: json['first_surname'],
//       id: json['id'],
//       permissions:
//           Map<String, Map<String, List<String>>>.from(json['permissions']),
//       role: json['role'],
//       secondName: json['second_name'],
//       secondSurname: json['second_surname'],
//       token: json['token'],
//     );
//   }
// }

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    final permissionsJson = json['permissions'] as Map<String, dynamic>;
    final usuariosJson = permissionsJson['usuarios'] as List<dynamic>;
    final usuarios = usuariosJson.cast<String>().toList();

    return User(
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      firstSurname: json['first_surname'] as String,
      id: json['id'] as int,
      permissions: {
        'usuarios': {
          'permissions': usuarios,
        },
      },
      role: json['role'] as int,
      secondName: json['second_name'] as String,
      secondSurname: json['second_surname'] as String,
      token: json['token'] as String,
    );
  }
}
