import 'package:flutter/material.dart';

import 'api/scope.dart';
import 'todo_list.dart';

class ScopeList extends StatefulWidget {
  @override
  _ScopeListState createState() => _ScopeListState();
}

class _ScopeListState extends State<ScopeList> {
  Future<List<Scope>> _futureScopes;

  Future<List<Scope>> fetchScopes() {
    setState(() { _futureScopes = Scope.fetchScopes(); });
    return _futureScopes;
  }

  Future<void> _handleRefresh() async {
    await fetchScopes();
    return null;
  }

  @override
  void initState() {
    fetchScopes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Scopes'),
    ),
    drawer: Drawer(),
    body: Center(
        child: FutureBuilder<List<Scope>>(
          future: _futureScopes,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              return snapshot.data.length > 0
                ? RefreshIndicator(child: ListView(children: _getScopes(snapshot.data)), onRefresh: _handleRefresh)
                : _getNoScopes();
            }
            return CircularProgressIndicator();
          })
      ),
    floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        tooltip: 'Create Scope',
        child: Icon(Icons.add),
      ),
  );
  }

  List<Widget> _getScopes(List<Scope> scopes) {
    var widgets = List<Widget>();
    scopes.forEach((scope) {
      widgets.add(ListTile(
        title: Text(scope.name),
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TodoList(scope.id))
          );
        },
      ));
      widgets.add(Divider(color: Theme.of(context).accentColor));
    });
    return widgets;
  }

  Widget _getNoScopes() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Text('Nothing here... Create a Scope!')
    );
  }
}