import 'package:flutter/material.dart';
import 'package:hn_app/services/auth/auth_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants/routes.dart';
import '../enums/menu_action.dart';
import '../main.dart';
import '../src/article.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key, required this.title});
  final String title;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HackerNews'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            PopupMenuButton(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(routerRoute, (_) => false);
                    }
                  default:
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text('Log out')),
                ];
              },
            )
          ],
        ),
        body: ListView(
          children: _articles.map(_buildItems).toList(),
        ),
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