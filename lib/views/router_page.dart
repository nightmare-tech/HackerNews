import 'package:flutter/material.dart';
import 'package:hn_app/views/login_view.dart';
import 'package:hn_app/views/register_view.dart';


class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
        child: ListView(
          padding: EdgeInsets.all(10),
          children: const [
            ExpansionTile(
              title: Text("Login"),
              children: [
                LoginView(),
              ],
              // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            ExpansionTile(
              title: Text("Sign Up"),
              children: [RegisterView()],
            )
          ],
        ),
      ),
    );
  }
}
