import 'package:flutter/material.dart';
import 'package:open_todos_flutter_frontend/api/todos.dart';
import 'package:open_todos_flutter_frontend/todo_drawer.dart';
import 'package:provider/provider.dart';

import 'package:open_todos_flutter_frontend/api/todo.dart';
import 'package:open_todos_flutter_frontend/login_screen_builder.dart';
import 'package:open_todos_flutter_frontend/todo_form.dart';

class TodoList extends StatefulWidget {
  const TodoList();

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  Future<List<Todo>> _futureTodos;

  Future<List<Todo>> fetchAndSetTodos(Todos todos) {
    setState(() {
      _futureTodos = todos.fetchTodos();
    });
    return _futureTodos;
  }

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<Todos>();
    fetchAndSetTodos(todos);
    return LoginScreenBuilder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              children: <Widget>[
                Text(
                  'Todos',
                  textScaleFactor: 1.7 * 0.618,
                ),
                Text(todos.scope.name, textScaleFactor: 1.7 * 0.382)
              ],
            ),
          ),
          drawer: TodoDrawer(),
          body: Center(
              child: FutureBuilder<List<Todo>>(
                  future: _futureTodos,
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } else if (snapshot.hasData) {
                      return snapshot.data.length > 0
                          ? RefreshIndicator(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(
                                    children: _getTodos(snapshot.data, todos)),
                              ),
                              onRefresh: () => fetchAndSetTodos(todos))
                          : _getNoTodos();
                    }
                    return CircularProgressIndicator();
                  })),
          floatingActionButton: FloatingActionButton(
            onPressed: () => TodoForm.pushOnContext(
                context, () => fetchAndSetTodos(todos), Todo(todos.scope)),
            tooltip: 'Create Todo',
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  List<Widget> _getTodos(List<Todo> todoList, Todos todos) {
    var widgets = List<Widget>();
    todoList.forEach((todo) {
      widgets.add(ListTile(
        leading: Icon(todo.getProgressIcon()),
        title: Text(todo.name),
        trailing: Icon(todo.getIcon()),
        onTap: () {
          todos.setCurrentTodo(todo);
          TodoForm.pushOnContext(context, () => fetchAndSetTodos(todos), todo);
        },
      ));
      widgets.add(Divider(color: Colors.blueGrey));
    });
    return widgets;
  }

  Widget _getNoTodos() {
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text('Nothing here... Create some Todos!'));
  }
}
