import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

import 'package:open_todos_flutter_frontend/api/scopes.dart';
import 'package:open_todos_flutter_frontend/api/todos.dart';
import 'package:open_todos_flutter_frontend/api/api_service.dart';
import 'package:open_todos_flutter_frontend/widgets/scope_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  runApp(OpenTodos());
}

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
              update: (_, service, scopes) {
                // to trigger notifyListeners() which is only accessible internally
                // we call this setter with the current value
                scopes.setScope(scopes.scope);
                return scopes;
              }),
          ChangeNotifierProxyProvider2<APIService, Scopes, Todos>(
            create: (_) => Todos(APIService(), null),
            update: (_, service, scopes, todos) {
              todos.setScope(scopes.scope);
              if (scopes.scope == null || scopes.scope.id != todos.scope.id) {
                todos.setTodo(null);
              }
              todos.setScope(scopes.scope);
              return todos;
            },
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
