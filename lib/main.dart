import 'package:flutter/material.dart';
import 'package:lsb_translator/config/user/user_config.dart';
import 'package:lsb_translator/presentation/providers/user_prodivder.dart';
import 'package:lsb_translator/presentation/screens/home/home_screen.dart';
import 'package:lsb_translator/config/theme/app_theme.dart';
import 'package:lsb_translator/presentation/screens/login/login_screen.dart';
import 'package:lsb_translator/presentation/screens/profile/profile_screen.dart';
import 'package:lsb_translator/presentation/screens/reacord/record_screen.dart';
import 'package:lsb_translator/presentation/screens/translate/translate_screen.dart';
import 'package:provider/provider.dart';

// void main() => runApp(const ProviderScope(
//       child: MyApp(),
//     ));

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => UserProvider(userConfiguration: UserConfiguration()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Traductor LSB",
        theme: AppTheme().getTheme(),
        initialRoute: "/",
        routes: {
          "/": (context) => const HomeScreen(),
          "/login": (context) => const LoginScreen(),
          "/profile": (context) => const ProfileScreen(),
          // "/manual": (context) => const HomeScreen(),
          "/translate": (context) => const TranslateScreen(),
          "/record_video": (context) => const RecordScreen(),
        },
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          );
        },
      ),
    );
  }
}
