import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_todos_flutter_frontend/api/scope.dart';
import 'package:open_todos_flutter_frontend/api_service.dart';
import 'package:open_todos_flutter_frontend/api/scopes.dart';

class TodoDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();
    final scopes = context.watch<Scopes>();
    return Drawer(
      child: FutureBuilder(
        future: context.watch<APIService>().loggedIn(),
        builder: (context, tokenSnapshot) => FutureBuilder(
            future: scopes.fetchScopes(),
            builder: (context, scopesSnapshot) {
              List<Widget> children = [];
              if (scopesSnapshot.hasData) {
                List<Scope> scopes = scopesSnapshot.data;
                children.add(DrawerHeader(
                    child: Text('Scopes',
                        style: Theme.of(context).textTheme.headline5)));
                children.addAll(scopes.map((e) => ListTile(
                      title: Text(e.name),
                    )));
              } else if (!scopesSnapshot.hasError) {
                children.add(ListTile(title: CircularProgressIndicator()));
              } else {
                // TODO: retry
              }

              if (!tokenSnapshot.hasError &&
                  tokenSnapshot.hasData &&
                  tokenSnapshot.data) {
                children.add(Divider());
                children.add(ListTile(
                  trailing: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () => apiService.logOut(),
                ));
              }

              return ListView(children: children);
            }),
      ),
    );
  }
}
