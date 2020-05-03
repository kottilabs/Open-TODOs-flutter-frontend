import 'dart:convert';
import 'package:http/http.dart';

import 'constants.dart';

class Scope {
  String id;
  String name;
  String parentScope;

  static const ID_KEY = 'id';
  static const NAME_KEY = 'name';
  static const PARENT_SCOPE_KEY = 'parentScope';

  Scope(String parentScope) {
    this.id = null;
    this.name = '';
    this.parentScope = parentScope;
  }

  Scope.fromJson(Map<String, dynamic> json) {
    id = json[ID_KEY];
    name = json[NAME_KEY];
    parentScope = json[PARENT_SCOPE_KEY];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, String>();

    map[ID_KEY] = id;
    map[NAME_KEY] = name;
    map[PARENT_SCOPE_KEY] = parentScope;

    return map;
  }

  Future<Scope> save() async {
    if (id != null) {
      return put();
    } else {
      return post();
    }
  }

  Future<Scope> post() async {
    var map = this.toMap();
    map.remove(ID_KEY);
    final body = json.encode(map);
    return client
        .post("$BACKEND_URL/scope", body: body, headers: headers)
        .then((Response response) {
      if (response.statusCode == 200) {
        return Scope.fromJson(json.decode(response.body));
      }
      throw json.decode(response.body)['message'];
    });
  }

  Future<Scope> put() async {
    var map = this.toMap();
    final body = json.encode(map);
    return client
        .put("$BACKEND_URL/scope/$id", body: body, headers: headers)
        .then((Response response) {
      if (response.statusCode == 200) {
        return Scope.fromJson(json.decode(response.body));
      }
      throw json.decode(response.body)['message'];
    });
  }

  static Future<List<Scope>> fetchScopes() async {
    final response = await client.get("$BACKEND_URL/scope");

    if (response.statusCode == 200) {
      List todos = json.decode(response.body);
      return todos.map((todo) => Scope.fromJson(todo)).toList();
    }
    throw json.decode(response.body)['message'];
  }
}
