import 'package:flutter/material.dart';
import 'package:github_dashboard/widgets/list_repos.dart';
import 'package:github_dashboard/widgets/repos_item.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:github_dashboard/provider/list_repo_provider.dart';

class SearchBar extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _SearchBarState createState() => new _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  // controls the text label we use as a search bar
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  String listOrRepo = "list";
  List names = new List(); // names we get from API
  List filteredNames = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search a GitHub User');

  _SearchBarState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }
  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _filter.text =
        Provider.of<ListReposProvider>(context, listen: false).username;
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: listOrRepo == "list" ? _buildList() : ListRepos(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: new InkWell(
        child: _appBarTitle,
        onTap: _searchPressed,
      ),
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['login']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        // print(filteredNames[index]['login']);
        return Container(
          height: 50,
          //color: Colors.amber[colorCodes[index]],
          child: Center(child: Text('${filteredNames[index]['login']}')),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  void _searchPressed() {
    final getUserRepos =
        Provider.of<ListReposProvider>(context, listen: false).getUserRepos;
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          style: TextStyle(fontSize: 20),
          controller: _filter,
          onSubmitted: (string) =>
              [getUserRepos(_filter.text), listOrRepo = "repo"],
          decoration: new InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.teal,
                ),
              ),
              prefixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    getUserRepos(_filter.text);
                    listOrRepo = "repo";
                  })),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this.listOrRepo = "list";
        this._appBarTitle = new Text('Search Another User');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames() async {
    //FAUDRAIT JUSTE CHOPER LES USERS DE VISEO TECH ET APRES ON REFAIT UN CALL API AVEC LE NOM DE L4USER SPECIFIQUE
    final response = await dio.get('https://api.github.com/users?since=000');

    List tempList = new List();

    for (int i = 0; i < response.data.length; i++) {
      tempList.add(response.data[i]);
    }
    print(tempList);

    setState(() {
      names = tempList;
      names.shuffle();
      filteredNames = names;
    });
  }
}
