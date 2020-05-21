import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_todos_flutter_frontend/api/scope.dart';
import 'package:open_todos_flutter_frontend/api/api_service.dart';
import 'package:open_todos_flutter_frontend/api/scopes.dart';
import 'package:open_todos_flutter_frontend/widgets/scope_form.dart';

class TodoDrawer extends StatefulWidget {
  @override
  _TodoDrawerState createState() => _TodoDrawerState();
}

class _TodoDrawerState extends State<TodoDrawer> {
  Future<List<Scope>> fetchAndSetScopes(Scopes scopes) {
    setState(() {
      _scopesFuture = scopes.fetchScopes();
    });
    return _scopesFuture;
  }

  void _showDeleteDialog(
      BuildContext context, APIService apiService, Scopes scopes, Scope scope) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                "This action will delete ${scope.name} and all associated Todos."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Delete"),
                onPressed: () {
                  scope.delete(apiService).then((value) => fetchAndSetScopes(scopes));
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<List<Scope>> _scopesFuture;
  @override
  Widget build(BuildContext context) {
    final scopes = context.watch<Scopes>();
    if (_scopesFuture == null) {
      _scopesFuture = scopes.fetchScopes();
    }
    final apiService = context.watch<APIService>();
    return Drawer(
      child: FutureBuilder(
          future: _scopesFuture,
          builder: (context, scopesSnapshot) {
            List<Widget> children = [];
            if (scopesSnapshot.hasData) {
              List<Scope> scopeList = scopesSnapshot.data;
              children.add(Container(
                height: 46,
                child: ListTile(
                  title: Text('Scopes',
                      style: Theme.of(context).textTheme.headline5),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => ScopeForm.pushOnContext(
                        context, () => fetchAndSetScopes(scopes), Scope(null)),
                  ),
                ),
              ));
              children.add(Divider());
              children.addAll(scopeList.map((scope) => ListTile(
                    title: Text(scope.name),
                    onTap: () {
                      scopes.setScope(scope);
                      Navigator.pop(context);
                    },
                    onLongPress: () =>
                        _showDeleteDialog(context, apiService, scopes, scope),
                  )));
            } else if (!scopesSnapshot.hasError) {
              children.add(ListTile(
                title: Center(
                  child: CircularProgressIndicator(),
                ),
              ));
            } else {
              // TODO: retry
            }

            children.add(Divider(
              height: 5,
            ));
            children.add(ListTile(
              trailing: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => apiService.logOut(),
            ));

            return RefreshIndicator(
              child: ListView(children: children),
              onRefresh: () => fetchAndSetScopes(scopes),
            );
          }),
    );
  }
}
