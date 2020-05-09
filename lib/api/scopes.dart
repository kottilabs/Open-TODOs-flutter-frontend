import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:open_todos_flutter_frontend/api/scope.dart';
import 'package:open_todos_flutter_frontend/api_service.dart';

class Scopes with ChangeNotifier {
  final APIService service;
  Scopes(this.service, {this.currentScope});

  Scope currentScope;

  Future<List<Scope>> fetchScopes() {
    return service.get("${APIService.BACKEND_URL}/scope").then((response) {
      if (response.statusCode == 200) {
        List todos = json.decode(response.body);
        return todos.map((todo) => Scope.fromJson(todo)).toList();
      }
      throw json.decode(response.body)['message'];
    });
  }

  void setCurrentScope(Scope scope) {
    currentScope = scope;
    notifyListeners();
  }
}
