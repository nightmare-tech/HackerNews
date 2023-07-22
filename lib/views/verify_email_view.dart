import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hn_app/constants/routes.dart';

import '../main.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
          const Duration(seconds: 3), (timer) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger(
        child: Text(e.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage()
      : Scaffold(
          appBar: AppBar(
            title: const Text('Verify email address'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: ListView(children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                  "A verification email has been sent to your email address. Please check your inbox to complete the registration process.",
                  style: TextStyle(fontSize: 25)),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                  "If you don't see the email in your inbox, please check your spam or junk folder.",
                  style: TextStyle(fontSize: 20)),
            ),
            TextButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  const HomePage();
                },
                child: const Text(
                  'Resend',
                  style: TextStyle(fontSize: 20),
                )),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false,
                  );
                },
                child: const Text(
                  'Restart',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ]));
}
