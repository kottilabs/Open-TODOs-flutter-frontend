import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';

class APIService extends http.BaseClient with ChangeNotifier {
  final headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  FlutterSecureStorage _storage = new FlutterSecureStorage();
  Future<String> _token;
  String backendUrl = GlobalConfiguration().getString("default_backend_url");
  APIService._internal();
  http.Client _httpClient = new http.Client();

  static final APIService _singleton = APIService._internal();

  factory APIService() {
    if (_singleton._token == null) {
      _singleton._token = _singleton._storage.read(key: 'token');
    }
    return _singleton;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (GlobalConfiguration().getBool('force_https') &&
        request.url.scheme != "https") {
      return Future.value(null);
    }

    return _token.then((token) {
      if (token != null) {
        request.headers['authorization'] = 'Bearer $token';
      }
      return request;
    }).then((request) => _httpClient.send(request));
  }

  @override
  Future<http.Response> get(url, {Map<String, String> headers}) {
    return super.get(url, headers: headers).then((response) {
      if (response.statusCode == 401) {
        logOut();
      }
      return response;
    });
  }

  @override
  Future<http.Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return super
        .post(url, headers: headers, body: body, encoding: encoding)
        .then((response) {
      if (response.statusCode == 401) {
        logOut();
      }
      return response;
    });
  }

  @override
  Future<http.Response> patch(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return super
        .patch(url, headers: headers, body: body, encoding: encoding)
        .then((response) {
      if (response.statusCode == 401) {
        logOut();
      }
      return response;
    });
  }

  @override
  Future<http.Response> delete(url, {Map<String, String> headers}) {
    return super.delete(url, headers: headers).then((response) {
      if (response.statusCode == 401) {
        logOut();
      }
      return response;
    });
  }

  void _setToken(String token) {
    _token.then((value) async {
      if (value == token) return;
      if (token == null) {
        await _storage.delete(key: 'token');
      } else {
        await _storage.write(key: 'token', value: token);
      }
      _token = Future.value(token);
      notifyListeners();
    });
  }

  Future<bool> login(String username, String password) {
    logOut();

    final body = json.encode({'username': username, 'password': password});
    return post("$backendUrl/auth/login", body: body, headers: headers)
        .then((response) {
      if (response.statusCode == 200) {
        _setToken(json.decode(response.body)["token"]);
        return true;
      }
      return false;
    });
  }

  Future<bool> loggedIn() async {
    return (await _token) != null;
  }

  void logOut() {
    _token.then((token) {
      if (token == null) {
        return;
      }
      post("$backendUrl/auth/logout").then((response) {
        if (response.statusCode == 200) {}
        _setToken(null);
      });
    });
  }
}
