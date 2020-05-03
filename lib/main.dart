import 'package:flutter/material.dart';

import 'scope_list.dart';

void main() => runApp(OpenTodos());

class OpenTodos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos',
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        accentColor: Colors.blue,
      ),
      home: ScopeList(),
    );
  }
}
