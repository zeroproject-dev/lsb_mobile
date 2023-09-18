bool isValidEmail(String email) {
  final emailRegEx = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

  return emailRegEx.hasMatch(email);
}
