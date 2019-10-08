import 'package:flutter/material.dart';
import 'package:github_dashboard/provider/list_repo_provider.dart';
import 'package:github_dashboard/provider/repos_provider.dart';
import 'package:github_dashboard/widgets/repos_item.dart';
import 'package:provider/provider.dart';

class ListRepos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final listReposProvider = Provider.of<ListReposProvider>(context);
    final List<ReposProvider> listRepos = listReposProvider.listRepos;
    final bool isLoading = listReposProvider.isLoading;
    return isLoading
        ? Center(
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      ),
    )
        : ListView.builder(
      itemCount: listRepos.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: listRepos[index], child: ReposItem()),
    );
  }
}