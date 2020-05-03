import 'package:flutter/material.dart';

import 'scope_list.dart';

void main() => runApp(OpenTODOs());

class OpenTODOs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOs',
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        accentColor: Colors.blue,
      ),
      home: ScopeList(),
    );
  }
}
