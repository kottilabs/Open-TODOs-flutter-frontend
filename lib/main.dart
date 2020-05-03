import 'package:flutter/material.dart';

import 'todo.dart';
import 'todo_form.dart';

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
      home: TodoList(title: 'TODOs'),
    );
  }
}

class TodoList extends StatefulWidget {
  TodoList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  Future<List<Todo>> _futureTodos;

  Future<List<Todo>> fetchTodos(String scopeId) {
    setState(() { _futureTodos = fetchScope(scopeId); });
    return _futureTodos;
  }

  Future<void> _handleRefresh() async {
    await fetchTodos(Todo.SAMPLE_SCOPE_ID);
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTodos(Todo.SAMPLE_SCOPE_ID);
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TodoForm()));
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
