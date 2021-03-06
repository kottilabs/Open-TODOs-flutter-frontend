import 'dart:convert';
import 'package:http/http.dart';
import 'package:open_todos_flutter_frontend/api/api_service.dart';
import 'api_service.dart';

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

  Scope.fromResponse(Response response) {
    if (response.statusCode == 200) {
      Scope.fromJson(json.decode(response.body));
    } else {
      throw json.decode(response.body)['message'];
    }
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

  Future<Scope> save(APIService service) {
    if (id != null) {
      return put(service);
    } else {
      return post(service);
    }
  }

  Future<Scope> post(APIService service) {
    var map = this.toMap();
    map.remove(ID_KEY);
    final body = json.encode(map);
    return service
        .post("${service.backendUrl}/scope",
            body: body, headers: service.headers)
        .then((Response response) {
      if (response.statusCode == 200) {
        return Scope.fromJson(json.decode(response.body));
      }
      throw json.decode(response.body)['message'];
    });
  }

  Future<Scope> put(APIService service) {
    var map = this.toMap();
    final body = json.encode(map);
    return service
        .put("${service.backendUrl}/scope/$id",
            body: body, headers: service.headers)
        .then((Response response) => Scope.fromResponse(response));
  }

  Future<Scope> delete(APIService service) {
    return service
        .delete("${service.backendUrl}/scope/$id", headers: service.headers)
        .then((response) => Scope.fromResponse(response));
  }

  isPersisted() {
    return id != null;
  }
}
