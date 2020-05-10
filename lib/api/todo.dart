import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:open_todos_flutter_frontend/api/scope.dart';
import 'package:open_todos_flutter_frontend/api/api_service.dart';

enum Status { TODO, DOING, TESTING, DONE }

class Todo {
  String id;
  String name;
  String scopeId;
  String description;
  Status state;
  String icon;

  static const ID_KEY = 'id';
  static const NAME_KEY = 'name';
  static const SCOPE_ID_KEY = 'scopeId';
  static const DESCRIPTION_KEY = 'description';
  static const STATE_KEY = 'state';
  static const ICON_KEY = 'icon';

  Todo(Scope scope) {
    this.id = null;
    this.name = '';
    this.scopeId = scope.id;
    this.description = '';
    this.state = Status.TODO;
    this.icon = null;
  }

  bool isPersisted() {
    return id != null;
  }

  Todo.fromJson(Map<String, dynamic> json) {
    id = json[ID_KEY];
    name = json[NAME_KEY];
    scopeId = json[SCOPE_ID_KEY];
    description = json[DESCRIPTION_KEY];
    state = EnumToString.fromString(Status.values, json[STATE_KEY]);
    icon = json[ICON_KEY];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, String>();

    map[ID_KEY] = id;
    map[NAME_KEY] = name;
    map[SCOPE_ID_KEY] = scopeId;
    map[DESCRIPTION_KEY] = description;
    map[STATE_KEY] = EnumToString.parse(state);
    map[ICON_KEY] = icon;

    return map;
  }

  IconData getIcon() {
    return Icons.zoom_in;
  }

  IconData getProgressIcon() {
    switch (state) {
      case Status.TODO:
        return Icons.check_box_outline_blank;
        break;

      case Status.DOING:
        return Icons.edit;
        break;

      case Status.TESTING:
        return Icons.spellcheck;
        break;

      case Status.DONE:
        return Icons.check;
        break;
    }
    throw 'Missing icon for $state';
  }

  Future<Todo> save(APIService service) {
    if (id != null) {
      return put(service);
    } else {
      return post(service);
    }
  }

  Future<Todo> post(APIService service) {
    var map = this.toMap();
    map.remove(ID_KEY);
    final body = json.encode(map);
    return service
        .post("${service.backendUrl}/todo/$scopeId",
            body: body, headers: service.headers)
        .then((Response response) {
      if (response.statusCode == 200) {
        return Todo.fromJson(json.decode(response.body));
      }
      throw json.decode(response.body)['message'];
    });
  }

  Future<Todo> put(APIService service) {
    var map = this.toMap();
    final body = json.encode(map);
    return service
        .put("${service.backendUrl}/todo/$scopeId/$id",
            body: body, headers: service.headers)
        .then((Response response) {
      if (response.statusCode == 200) {
        return Todo.fromJson(json.decode(response.body));
      }
      throw json.decode(response.body)['message'];
    });
  }
}
