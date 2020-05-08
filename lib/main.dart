import 'package:flutter/material.dart';
import 'package:open_todos_flutter_frontend/api_service.dart';
import 'package:provider/provider.dart';

import 'scope_list.dart';

void main() => runApp(OpenTodos());

class OpenTodos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => APIService(),
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
