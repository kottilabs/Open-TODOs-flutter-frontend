import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_todos_flutter_frontend/api/scopes.dart';
import 'package:open_todos_flutter_frontend/api/todos.dart';
import 'package:open_todos_flutter_frontend/api_service.dart';
import 'package:open_todos_flutter_frontend/scope_list.dart';

void main() => runApp(OpenTodos());

class OpenTodos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => APIService(),
          ),
          ChangeNotifierProxyProvider<APIService, Scopes>(
            create: (_) => Scopes(APIService()),
            update: (_, service, oldScopes) =>
                Scopes(service, currentScope: oldScopes.currentScope),
          ),
          ChangeNotifierProxyProvider2<APIService, Scopes, Todos>(
            create: (_) => Todos(APIService(), null),
            update: (_, service, scopes, oldTodos) => Todos(
                service, scopes.currentScope,
                currentTodo: Todos.defaultTodo(
                    scopes.currentScope, oldTodos.currentTodo)),
          )
        ],
        child: MaterialApp(
          title: 'Todos',
          theme: ThemeData(
            primaryColor: Colors.blue[900],
            accentColor: Colors.blue,
          ),
          home: ScopeList(),
        ));
  }
}
