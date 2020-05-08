import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_todos_flutter_frontend/api_service.dart';
import 'package:open_todos_flutter_frontend/login_screen_builder.dart';

import 'api/scope.dart';
import 'todo_list.dart';

class ScopeList extends StatefulWidget {
  @override
  _ScopeListState createState() => _ScopeListState();
}

class _ScopeListState extends State<ScopeList> {
  Future<List<Scope>> _futureScopes;

  Future<List<Scope>> fetchScopes(APIService service) {
    setState(() {
      _futureScopes = Scope.fetchScopes(service);
    });
    return _futureScopes;
  }

  Future<void> _handleRefresh(APIService service) async {
    await fetchScopes(service);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();
    return LoginScreenBuilder(builder: (context) {
      if (_futureScopes == null) {
        _futureScopes = Scope.fetchScopes(apiService);
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
                              child:
                                  ListView(children: _getScopes(snapshot.data)),
                            ),
                            onRefresh: () => _handleRefresh(apiService))
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

  List<Widget> _getScopes(List<Scope> scopes) {
    var widgets = List<Widget>();
    scopes.forEach((scope) {
      widgets.add(ListTile(
        title: Text(scope.name),
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => TodoList(scope)));
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
