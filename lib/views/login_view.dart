import 'package:flutter/material.dart';
import 'package:hn_app/constants/routes.dart';
import 'package:hn_app/services/auth/auth_exceptions.dart';
import 'package:hn_app/services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        enableSuggestions: false,
                        controller: _email,
                        decoration: const InputDecoration(hintText: 'Email'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        controller: _password,
                        decoration: const InputDecoration(hintText: 'Password'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextButton(
                        onPressed: () async {
                          try {
                            final email = _email.text.trim();
                            final password = _password.text.trim();
                            await AuthService.firebase()
                                .logIn(
                              email: email,
                              password: password,
                            )
                                .then(
                              (value) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  verifyEmailRoute,
                                  (route) => false,
                                );
                              },
                            );
                          } on WrongEmailOrPasswordAuthException{
                            await showErrorDialog(
                              context,
                              'Incorrect email or password!',
                            );
                          } on GenericAuthException {
                              await showErrorDialog(
                              context,
                              'Authentication Error',);
                          }
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            registerRoute,
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(fontSize: 16),
                        ))
                  ],
                );

              default:
                return const Text('Loading...');
            }
          },
        ),
      ),
    );
  }
}
