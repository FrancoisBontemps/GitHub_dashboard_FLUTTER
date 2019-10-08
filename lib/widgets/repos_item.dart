import 'package:flutter/material.dart';
import 'package:github_dashboard/provider/repos_provider.dart';
import 'package:github_dashboard/widgets/detail_repos.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReposItem extends StatelessWidget {
  void showDetailRepos(BuildContext ctx, ReposProvider value) {
    showModalBottomSheet(context: ctx, builder: (_) => DetailRepos(value));
  }



  @override
  Widget build(BuildContext context) {
    final ReposProvider repos =
    Provider.of<ReposProvider>(context, listen: false);
    return InkWell(
      onTap: () => showDetailRepos(context, repos),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        elevation: 1,
        child: ListTile(
          title: Text(
            repos.name,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(
            repos.description != null ? repos.description : '',
          ),
        ),
      ),
    );
  }
}