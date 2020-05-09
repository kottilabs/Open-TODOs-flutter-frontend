import 'package:flutter/material.dart';
import 'package:open_todos_flutter_frontend/api/scope.dart';
import 'package:open_todos_flutter_frontend/api_service.dart';
import 'package:provider/provider.dart';

import 'package:open_todos_flutter_frontend/api/scopes.dart';

class TodoDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();
    final scopes = context.watch<Scopes>();
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
            child:
                Text('Scopes', style: Theme.of(context).textTheme.headline5)),
        FutureBuilder(
            future: scopes.fetchScopes(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                List<Scope> scopes = snapshot.data;
                return ListTile(title: Text('abc'));
              }
              return Center(child: CircularProgressIndicator());
            }),
        ListTile(
          trailing: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () => apiService.logOut(),
        )
      ]),
    );
  }
}
