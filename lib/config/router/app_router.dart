import 'package:go_router/go_router.dart';
import 'package:lsb_translator/presentation/screens/home/home_screen.dart';
import 'package:lsb_translator/presentation/screens/login/login_screen.dart';
import 'package:lsb_translator/presentation/screens/profile/profile_screen.dart';
import 'package:lsb_translator/presentation/screens/reacord/record_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/reocord-video',
      builder: (context, state) => const RecordScreen(),
    ),
  ],
);
