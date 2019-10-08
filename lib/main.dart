import 'package:flutter/material.dart';
import 'package:github_dashboard/provider/list_repo_provider.dart';
import 'package:github_dashboard/screens/search_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ChangeNotifierProvider<ListReposProvider>.value(
        value: ListReposProvider(),
        child: MaterialApp(
          title: 'Flutter Api Filter list Demo',
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: new SearchBar(),
        ));
  }
}
