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
  void _showDeleteDialog(BuildContext context, Scopes scopes, Scope scope) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                "This action will delete Scope ${scope.name} and all associated Todos."),
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
                  scopes.deleteScope(scope);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();
    final scopes = context.watch<Scopes>();
    return Drawer(
      child: FutureBuilder(
          future: scopes.fetchScopes(),
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
                    onPressed: () => ScopeForm.pushOnContext(context,
                        (newScope) => scopes.setScope(newScope), Scope(null)),
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
                    selected: scope == scopes.scope,
                    onLongPress: () =>
                        _showDeleteDialog(context, scopes, scope),
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
              onRefresh: () => scopes.refresh(),
            );
          }),
    );
  }
}
