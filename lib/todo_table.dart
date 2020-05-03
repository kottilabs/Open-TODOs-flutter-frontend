import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'dart:async';

import 'todo.dart';

class TodoTable extends StatefulWidget {
  _TodoTableState createState() => _TodoTableState();
}

class _TodoTableState extends State<TodoTable> {
  Future<List<Todo>> _futureTodos;

  Future<List<Todo>> _fetchTodos(String scopeId) {
    setState(() { _futureTodos = fetchScope(scopeId); });
    return _futureTodos;
  }

  Future<void> _handleRefresh() async {
    await _fetchTodos(Todo.SAMPLE_SCOPE_ID);
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchTodos(Todo.SAMPLE_SCOPE_ID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: _futureTodos, 
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        if (snapshot.hasData) {
          return snapshot.data.length > 0
                    ? RefreshIndicator(child: ListView(children: _getTodos(snapshot.data)), onRefresh: _handleRefresh)
                    : _getNoElements();
        }
        return CircularProgressIndicator();
    });
  }

  List<Widget> _getTodos(List<Todo> todos) {
    var widgets = List<Widget>();
    todos.forEach((todo) {
      widgets.add(ListTile(
        leading: Icon(todo.getProgressIcon()),
        title: Text(todo.name),
        trailing: Icon(todo.getIcon()),
      ));
      widgets.add(Divider(color: Colors.blueGrey));
    });
    return widgets;
  }

  Widget _getNoElements() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Text('Nothing here... Create some TODOs!')
    );
  }
}