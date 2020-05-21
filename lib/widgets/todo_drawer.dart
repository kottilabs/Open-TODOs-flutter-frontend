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
              children.add(DrawerHeader(
                  child: Text('Scopes',
                      style: Theme.of(context).textTheme.headline5)));
              children.add(ListTile(
                title: Text('Create scope'),
                trailing: Icon(Icons.add),
                onTap: () => ScopeForm.pushOnContext(
                    context, () => fetchAndSetScopes(scopes), Scope(null)),
              ));
              children.add(Divider());
              children.addAll(scopeList.map((e) => ListTile(
                    title: Text(e.name),
                    onTap: () {
                      scopes.setScope(e);
                      Navigator.pop(context);
                    },
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
