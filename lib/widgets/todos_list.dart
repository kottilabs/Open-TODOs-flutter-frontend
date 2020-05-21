import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_todos_flutter_frontend/api/todo.dart';
import 'package:open_todos_flutter_frontend/api/todos.dart';
import 'package:open_todos_flutter_frontend/widgets/login_screen_builder.dart';
import 'package:open_todos_flutter_frontend/widgets/todo_form.dart';
import 'package:open_todos_flutter_frontend/widgets/todo_drawer.dart';
import 'package:open_todos_flutter_frontend/widgets/scopes_list_builder.dart';
import 'package:open_todos_flutter_frontend/widgets/scope_form.dart';

class TodosList extends StatefulWidget {
  const TodosList();

  @override
  _TodosListState createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  void _showDeleteDialog(BuildContext context, Todos todos, Todo todo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                "This action will delete Todo ${todo.name}."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Delete"),
                onPressed: () {
                  todos.deleteTodo(todo);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<Todos>();
    return LoginScreenBuilder(
      builder: (context) => ScopesListBuilder(builder: (context) {
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
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => ScopeForm.pushOnContext(context, (scope) => todos.setScope(scope), todos.scope),
              ),
            ],
          ),
          drawer: TodoDrawer(),
          body: Center(
              child: FutureBuilder<List<Todo>>(
                  future: todos.fetchTodos(),
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
                              onRefresh: () => todos.refresh())
                          : _getNoTodos();
                    }
                    return CircularProgressIndicator();
                  })),
          floatingActionButton: FloatingActionButton(
            onPressed: () => TodoForm.pushOnContext(
                context, (createdTodo) => todos.setTodo(createdTodo), Todo(todos.scope)),
            tooltip: 'Create Todo',
            child: Icon(Icons.add),
          ),
        );
      }),
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
          todos.setTodo(todo);
          TodoForm.pushOnContext(context, (editedTodo) => todos.setTodo(editedTodo), todo);
        },
        onLongPress: () => _showDeleteDialog(context, todos, todo),
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
