import 'package:flutter/material.dart';

import 'api/todo.dart';
import 'todo_form.dart';

class TodoList extends StatefulWidget {
  TodoList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  Future<List<Todo>> _futureTodos;
  // TODO: this will be injected by either UserDefaults or ScopeList
  String _scopeId = '6845d178-d8df-4cdd-ab11-b2c84c44e2c6';

  Future<List<Todo>> fetchTodos(String scopeId) {
    setState(() { _futureTodos = Todo.fetchTodos(scopeId); });
    return _futureTodos;
  }

  void callback() {
    fetchTodos(_scopeId);
  }

  Future<void> _handleRefresh() async {
    await fetchTodos(_scopeId);
    return null;
  }

  @override
  void initState() {
    fetchTodos(_scopeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Todo>>(
          future: _futureTodos,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              return snapshot.data.length > 0
                ? RefreshIndicator(child: ListView(children: _getTodos(snapshot.data)), onRefresh: _handleRefresh)
                : _getNoElements();
            }
            return CircularProgressIndicator();
          })
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openTodoForm(Todo(_scopeId));
        },
        tooltip: 'Create TODO',
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> _getTodos(List<Todo> todos) {
    var widgets = List<Widget>();
    todos.forEach((todo) {
      widgets.add(ListTile(
        leading: Icon(todo.getProgressIcon()),
        title: Text(todo.name),
        trailing: Icon(todo.getIcon()),
        onTap: () {
          _openTodoForm(todo);
        },
      ));
      widgets.add(Divider(color: Colors.blueGrey));
    });
    return widgets;
  }

  void _openTodoForm(Todo todo) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TodoForm(callback, todo)));
  }

  Widget _getNoElements() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Text('Nothing here... Create some TODOs!')
    );
  }
}