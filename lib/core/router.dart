import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const CupertinoPage(child: HomeScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) =>
          const CupertinoPage(child: ProfileScreen()),
    ),
  ],
);
