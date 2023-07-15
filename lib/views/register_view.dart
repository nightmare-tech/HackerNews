import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'verify_email_view.dart';
import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  Future checkEmailVerified() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password)
                                .then(
                              (value) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const VerifyEmailView()));
                              },
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Email already registered!')));
                            } else if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Weak Password!')));
                            } else if (e.code == 'invalid-email') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Invalid email address'),
                              ));
                            }
                          }
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login/', (route) => false);
                        },
                        child: const Text(
                          "Already have an account? Log in",
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
