import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'dart:async';

import 'todo.dart';

class TodoTable extends StatefulWidget {
  _TodoTableState createState() => _TodoTableState();
}

class _TodoTableState extends State<TodoTable> {
  Future<List<Todo>> _futureTodos;

  void fetchTodos() {
    setState(() { _futureTodos = fetchScope(Todo.SAMPLE_SCOPE_ID); });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    const threeSecs = const Duration(seconds:3);
    new Timer.periodic(threeSecs, (Timer t) => this.fetchTodos());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: _futureTodos, 
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  snapshot.data.length > 0
                    ? DataTable(columns: [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Status')),
                    ], rows: snapshot.data.map((todo) => DataRow(
                      cells: [
                        DataCell(Text(todo.name)),
                        DataCell(Text(todo.description)),
                        DataCell(Text(EnumToString.parse(todo.state))),
                      ])).toList()
                    )
                    : Padding(padding: const EdgeInsets.all(32.0),
                    child: Text('Nothing here... Create some TODOs!'))
                ],
              );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
    });
  }
}