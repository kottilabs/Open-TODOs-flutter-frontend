import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:open_todos_flutter_frontend/api/scope.dart';
import 'package:open_todos_flutter_frontend/api/api_service.dart';
import 'package:open_todos_flutter_frontend/globals.dart' as globals;

class Scopes with ChangeNotifier {
  APIService service;
  Scopes(this.service, {this.scope});

  Scope scope;

  Future<List<Scope>> fetchScopes() {
    return service.get("${service.backendUrl}/scope").then((response) {
      if (response.statusCode == 200) {
        List todos = json.decode(response.body);
        return todos.map((todo) => Scope.fromJson(todo)).toList();
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
}
