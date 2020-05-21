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

  void setService(APIService service) {
    if (this.service == service) return;
    this.service = service;
    notifyListeners();
  }

  void setScope(Scope scope) {
    this.scope = scope;
    notifyListeners();
  }

  void setTodo(Todo todo) {
    this.todo = todo;
    notifyListeners();
  }

  Future<void> refresh() {
    notifyListeners();
    return Future.value();
  }

  Future<Todo> deleteTodo(Todo todo) {
    return todo.delete(service).whenComplete(() => notifyListeners());
  }
}
