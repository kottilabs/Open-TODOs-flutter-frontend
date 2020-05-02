import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:enum_to_string/enum_to_string.dart';

const BACKEND_URL = '***REMOVED***/todo';
const SCOPE_ID = '7143b762-d5a8-449c-b97a-4f1953dceeb8';

enum Status {
  TODO,
  DOING,
  TESTING,
  DONE
}

class Todo {
  String id;
  String name;
  String scopeId;
  String description;
  Status state;

  Todo({this.id, this.name, this.scopeId, this.description, this.state});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      name: json['name'],
      scopeId: json['scopeId'],
      description: json['description'],
      state: EnumToString.fromString(Status.values, json['state']),
    );
  }
}

Future<List<Todo>> fetchScope() async {
  final response = await http.get("$BACKEND_URL/$SCOPE_ID");

  if (response.statusCode == 200) {
    List todos = json.decode(response.body);
    return todos.map((todo) => Todo.fromJson(todo)).toList();
  } else {
    throw json.decode(response.body)['message'];
  }
}
