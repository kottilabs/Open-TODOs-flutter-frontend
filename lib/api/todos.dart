import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:open_todos_flutter_frontend/api/scope.dart';
import 'package:open_todos_flutter_frontend/api/todo.dart';
import 'package:open_todos_flutter_frontend/api/api_service.dart';

class Todos with ChangeNotifier {
  final Scope scope;
  final APIService service;
  Todos(this.service, this.scope, {this.currentTodo});

  Todo currentTodo;

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
      throw json.decode(response.body)['message'];
    });
  }

  void setCurrentTodo(Todo todo) {
    currentTodo = todo;
    notifyListeners();
  }

  static Todo defaultTodo(Scope scope, Todo todo) {
    if (todo == null || scope.id != todo.scopeId) {
      return null;
    }
  return todo;
  }
}