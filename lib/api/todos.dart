import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:open_todos_flutter_frontend/api/scope.dart';
import 'package:open_todos_flutter_frontend/api/todo.dart';
import 'package:open_todos_flutter_frontend/api/api_service.dart';

import 'package:open_todos_flutter_frontend/globals.dart' as globals;

class Todos with ChangeNotifier {
  Scope scope;
  APIService service;
  Todo todo;

  Todos(this.service, this.scope, {this.todo});

  Future<List<Todo>> fetchTodos() {
    if (scope == null) {
      return Future.value([]);
    }
    return service
        .get("${service.backendUrl}/todo/${scope.id}")
        .then((response) {
      if (response.statusCode == 200) {
        List todos = json.decode(response.body);
        return todos.map((todo) => Todo.fromJson(todo)).toList();
      }
      globals.logAndThrowUnsuccessfulResponse(response);
      return null;
    });
  }

  void setScope(Scope scope) {
    if (this.scope != scope) {
      this.scope = scope;
      notifyListeners();
    }
  }

  void setTodo(Todo todo) {
    if (this.todo != todo) {
      this.todo = todo;
      notifyListeners();
    }
  }
}
