import 'package:flutter/material.dart';
import 'package:open_todos_flutter_frontend/widgets/todos_list.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

import 'package:open_todos_flutter_frontend/api/scopes.dart';
import 'package:open_todos_flutter_frontend/api/todos.dart';
import 'package:open_todos_flutter_frontend/api/api_service.dart';

import 'widgets/login_screen.dart';

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
              create: (_) => Scopes(),
              update: (_, service, scopes) {
                scopes.setService(service);
                return scopes;
              }),
          ChangeNotifierProxyProvider2<APIService, Scopes, Todos>(
            create: (_) => Todos(),
            update: (_, service, scopes, todos) {
              todos.setService(service);
              todos.setScope(scopes.scope);
              if (scopes.scope == null || scopes.scope.id != todos.scope.id) {
                todos.setTodo(null);
              }
              todos.setScope(scopes.scope);
              return todos;
            },
          )
        ],
        child: OpenTodosApp());
  }
}

class OpenTodosApp extends StatelessWidget {
  const OpenTodosApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos',
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        accentColor: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/todos': (context) => TodosList(),
      },
    );
  }
}
