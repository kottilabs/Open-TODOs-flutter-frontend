import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:enum_to_string/enum_to_string.dart';

const BACKEND_URL = '***REMOVED***/todo';

enum Status {
  TODO,
  DOING,
  TESTING,
  DONE
}

final headers = {
  'Content-type' : 'application/json', 
  'Accept': 'application/json',
};

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

  static const SAMPLE_SCOPE_ID = '6845d178-d8df-4cdd-ab11-b2c84c44e2c6';

  Todo(String scopeId) {
    this.id = null;
    this.name = '';
    this.scopeId = scopeId;
    this.description = '';
    this.state = Status.TODO;
    this.icon = null;
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

  Future<Todo> save() async {
    if (id != null) {
      return put();
    } else {
      return post();
    }
    
  }

  Future<Todo> post() async {
    var map = this.toMap();
    map.remove(ID_KEY);
    final body = json.encode(map);
    return http.post("$BACKEND_URL/$scopeId", body: body, headers: headers).then((http.Response response) {
      if (response.statusCode == 200) {
        return Todo.fromJson(json.decode(response.body));
      }
      throw json.decode(response.body)['message'];
    });
  }

  Future<Todo> put() async {
    var map = this.toMap();
    final body = json.encode(map);
    return http.put("$BACKEND_URL/$scopeId/$id", body: body, headers: headers).then((http.Response response) {
      if (response.statusCode == 200) {
        return Todo.fromJson(json.decode(response.body));
      }
      throw json.decode(response.body)['message'];
    });
  }
}

Future<List<Todo>> fetchScope(String scopeId) async {
  final response = await http.get("$BACKEND_URL/$scopeId");

  if (response.statusCode == 200) {
    List todos = json.decode(response.body);
    return todos.map((todo) => Todo.fromJson(todo)).toList();
  }
  throw json.decode(response.body)['message'];
}
