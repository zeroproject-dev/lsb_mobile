import 'package:flutter/material.dart';
import 'package:lsb_translator/config/helpers/validate_email.dart';
import 'package:lsb_translator/presentation/providers/user_prodivder.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    var user = context.watch<UserProvider>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    if (user.userConfiguration.isBiometricActive &&
        user.userConfiguration.haveCredentialsSaved &&
        !user.isAuth &&
        user.userConfiguration.isFirst) {
      user.loginBiometrics();
    }
    Future<void> navigateToHome() async {
      await Future.delayed(Duration.zero);
      () {
        Navigator.pushReplacementNamed(context, "/");
      }();
    }

    if (user.isAuth) {
      navigateToHome();
      return const Placeholder();
    }

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Spacer(),
              const Text(
                "Inicio de sesión",
                style: TextStyle(fontSize: 28),
              ),
              const Spacer(),
              Image.asset("assets/images/login_image.png"),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InputField.createEmail(
                          textController: emailController,
                          label: "Correo electrónico"),
                      const SizedBox(height: 10),
                      InputField.createPassword(
                          textController: passwordController,
                          label: "Contraseña"),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacementNamed(context, "/home");
                    },
                    child: const Text("Cancelar"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState == null ||
                          !formKey.currentState!.validate()) return;

                      final email = emailController.value.text;
                      final password = passwordController.value.text;

                      bool res = await user.login(email, password);

                      if (res) {
                        () {
                          Navigator.pushReplacementNamed(context, "/home");
                        }();
                      }
                    },
                    child: const Text("Ingresar"),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

enum InputType { email, password, text, number }

class InputField extends StatelessWidget {
  // final ValueChanged<String> onValue;
  final TextEditingController textController;
  final String label;
  final InputType type;

  const InputField({
    required this.textController,
    required this.label,
    required this.type,
    super.key,
  });

  const InputField.createEmail({
    required this.textController,
    required this.label,
    super.key,
  }) : type = InputType.email;

  const InputField.createText({
    required this.textController,
    required this.label,
    super.key,
  }) : type = InputType.text;

  const InputField.createPassword({
    required this.textController,
    required this.label,
    super.key,
  }) : type = InputType.password;

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    final outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    final inputDecoration = InputDecoration(
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      labelText: label,
      filled: true,
    );

    return TextFormField(
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      obscureText: type == InputType.password,
      focusNode: focusNode,
      controller: textController,
      decoration: inputDecoration,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Campo obligatorio";
        }

        switch (type) {
          case InputType.email:
            if (!isValidEmail(value)) return "Ingrese un correo válido";
          default:
        }
        return null;
      },
    );
  }
}
