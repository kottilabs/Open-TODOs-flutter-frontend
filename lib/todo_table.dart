import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'todo.dart';

class TodoTable extends StatefulWidget {
  _TodoTableState createState() => _TodoTableState();
}

class _TodoTableState extends State<TodoTable> {
  Future<List<Todo>> futureTodos;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    futureTodos = fetchScope();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: futureTodos, 
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
                    : Text('Nothing here... Create some TODOs!'),
                ],
              );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
    });
  }
}