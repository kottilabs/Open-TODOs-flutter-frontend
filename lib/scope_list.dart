import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_todos_flutter_frontend/api/scopes.dart';
import 'package:open_todos_flutter_frontend/api/scope.dart';
import 'package:open_todos_flutter_frontend/todo_list.dart';
import 'package:open_todos_flutter_frontend/login_screen_builder.dart';

class ScopeList extends StatefulWidget {
  @override
  _ScopeListState createState() => _ScopeListState();
}

class _ScopeListState extends State<ScopeList> {
  Future<List<Scope>> _futureScopes;

  Future<List<Scope>> fetchAndSetScopes(Scopes scopes) {
    setState(() {
      _futureScopes = scopes.fetchScopes();
    });
    return _futureScopes;
  }

  Future<void> _handleRefresh(Scopes scopes) async {
    await fetchAndSetScopes(scopes);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final scopes = context.watch<Scopes>();
    return LoginScreenBuilder(builder: (context) {
      if (_futureScopes == null) {
        _futureScopes = scopes.fetchScopes();
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scopes'),
        ),
        body: Center(
            child: FutureBuilder<List<Scope>>(
                future: _futureScopes,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return snapshot.data.length > 0
                        ? RefreshIndicator(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView(
                                  children: _getScopeWidgets(snapshot.data, scopes)),
                            ),
                            onRefresh: () => _handleRefresh(scopes))
                        : _getNoScopes();
                  }
                  return CircularProgressIndicator();
                })),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Create Scope',
          child: Icon(Icons.add),
        ),
      );
    });
  }

  List<Widget> _getScopeWidgets(List<Scope> scopeList, Scopes scopes) {
    var widgets = List<Widget>();
    scopeList.forEach((scope) {
      widgets.add(ListTile(
        title: Text(scope.name),
        onTap: () {
          scopes.setCurrentScope(scope);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => TodoList(),
          ));
        },
      ));
      widgets.add(Divider(color: Theme.of(context).accentColor));
    });
    return widgets;
  }

  Widget _getNoScopes() {
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text('Nothing here... Create a Scope!'));
  }
}
