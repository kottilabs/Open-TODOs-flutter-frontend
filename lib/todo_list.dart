import 'package:flutter/material.dart';
import 'package:open_todos_flutter_frontend/api_service.dart';
import 'package:open_todos_flutter_frontend/login_screen_builder.dart';
import 'package:provider/provider.dart';
import 'api/scope.dart';
import 'api/todo.dart';
import 'todo_form.dart';

class TodoList extends StatefulWidget {
  final Scope _initialScope;
  const TodoList(this._initialScope);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  Future<List<Todo>> _futureTodos;
  Scope _scope;

  @override
  void initState() {
    _scope = widget._initialScope;
    super.initState();
  }

  Future<List<Todo>> fetchTodos(APIService service, Scope scope) {
    setState(() {
      _futureTodos = Todo.fetchTodos(service, scope);
    });
    return _futureTodos;
  }

  void callback(APIService service) {
    fetchTodos(service, _scope);
  }

  Future<void> _handleRefresh(APIService service) async {
    await fetchTodos(service, _scope);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();
    fetchTodos(apiService, _scope);
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
                Text(_scope.name, textScaleFactor: 1.7 * 0.382)
              ],
            ),
          ),
          drawer: Drawer(),
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
                                    children:
                                        _getTodos(apiService, snapshot.data)),
                              ),
                              onRefresh: () => _handleRefresh(apiService))
                          : _getNoTodos();
                    }
                    return CircularProgressIndicator();
                  })),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _openTodoForm(Todo(_scope), () => callback(apiService));
            },
            tooltip: 'Create Todo',
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  List<Widget> _getTodos(APIService service, List<Todo> todos) {
    var widgets = List<Widget>();
    todos.forEach((todo) {
      widgets.add(ListTile(
        leading: Icon(todo.getProgressIcon()),
        title: Text(todo.name),
        trailing: Icon(todo.getIcon()),
        onTap: () {
          _openTodoForm(todo, () => callback(service));
        },
      ));
      widgets.add(Divider(color: Colors.blueGrey));
    });
    return widgets;
  }

  void _openTodoForm(Todo todo, Function callback) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TodoForm(callback, todo)));
  }

  Widget _getNoTodos() {
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text('Nothing here... Create some Todos!'));
  }
}
