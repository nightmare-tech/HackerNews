import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hn_app/constants/routes.dart';
import 'package:hn_app/services/auth/auth_service.dart';
import 'package:hn_app/views/article_page.dart';
import 'package:hn_app/views/login_view.dart';
import 'package:hn_app/views/register_view.dart';
import 'package:hn_app/views/router_page.dart';
import './views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        routerRoute: (context) => const RouterPage(),
        articlesRoute: (context) => const ArticlePage(
              title: "HackerNews",
            ),
        verifyEmailRoute: (context) => const VerifyEmailView()
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;

              if (user == null) {
                return const RouterPage();
              } else if (!user.isEmailVerified) {
                return const VerifyEmailView();
              } else {
                return const ArticlePage(title: 'HackerNews');
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}




Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log out')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'))
        ],
      );
    },
  ).then(
    (value) => value ?? false,
  );
}
