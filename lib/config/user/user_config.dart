import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserConfiguration {
  String? email;
  String? password;

  bool isBiometricActive = false;
  bool isBiometricAvailible = false;
  bool haveCredentialsSaved = false;
  bool isFirst = true;
  LocalAuthentication localAuth = LocalAuthentication();

  UserConfiguration() {
    _init();
  }

  void _init() async {
    isBiometricAvailible = await localAuth.canCheckBiometrics ||
        await localAuth.isDeviceSupported();

    load();
  }

  Future<bool> loginBiometric() async {
    isFirst = false;
    return await localAuth.authenticate(localizedReason: "Ingreso con huella");
  }

  void save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (email != null) await prefs.setString("email", email!);
    if (password != null) await prefs.setString("password", password!);
    await prefs.setBool("isBiometricActive", isBiometricActive);
  }

  void load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    email = prefs.getString("email");
    password = prefs.getString("password");

    isBiometricActive = prefs.getBool("isBiometricActive") ?? false;

    haveCredentialsSaved = email != null && password != null;
  }
}
