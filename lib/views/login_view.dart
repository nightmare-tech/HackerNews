import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

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
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
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
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            )
                                .then(
                              (value) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  "/verifyEmail/",
                                  (route) => false,
                                );
                              },
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found' ||
                                e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Incorrect email or password!')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "There was an unexpected error. Please try again later.")));
                            }
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
                            '/register/',
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
