import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hn_app/views/login_view.dart';
import 'package:hn_app/views/register_view.dart';
import 'package:hn_app/views/router_page.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'firebase_options.dart';
import 'src/article.dart';
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
        "/login/": (context) => const LoginView(),
        "/register/": (context) => const RegisterView(),
        "/router": (context) => const RouterPage()
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HackerNews'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: _signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;

              if (user == null) {
                return const RouterPage();
              } else if (!user.emailVerified) {
                return const VerifyEmailView();
              } else {
                return const MyHomePage(title: 'HackerNews');
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Article> _articles = articles;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _articles.removeAt(0);
        });
        return;
      },
      child: ListView(
        children: _articles.map(_buildItems).toList(),
      ),
    );
  }

  Widget _buildItems(Article article) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ExpansionTile(
        title: Text(
          article.text,
          style: const TextStyle(fontSize: 24),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('${article.commentsCount} comments'),
              IconButton(
                icon: const Icon(Icons.open_in_browser),
                onPressed: () async {
                  final fakeUrl = "http://${article.domain}";
                  if (!await launchUrlString(fakeUrl)) {
                    throw 'Could not launch $fakeUrl';
                  }
                },
                color: Colors.blueGrey,
              )
            ],
          ),
        ],
      ),
    );
  }
}
