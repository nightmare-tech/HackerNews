import 'package:flutter/material.dart';

class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
        children: [
          const Padding(
            padding: EdgeInsets.all(30),
            child: Text(
              'Welcome to HackerNews',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login/', (route) => false);
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 24),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/register/', (route) => false);
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 24),
                )),
          )
        ],
      ),
    );
  }
}
