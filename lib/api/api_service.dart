import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';

import 'package:open_todos_flutter_frontend/globals.dart' as globals;

class APIService extends http.BaseClient with ChangeNotifier {
  final String backendUrl =
      GlobalConfiguration().getString("default_backend_url");
  final headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  FlutterSecureStorage _storage = new FlutterSecureStorage();

  Future<String> _token;
  http.Client _httpClient = new http.Client();

  APIService() {
    _token = _storage.read(key: 'token');
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (GlobalConfiguration().getBool('force_https') &&
        request.url.scheme != "https") {
      globals.logger
          .w("Request blocked becuase scheme was not https: $request");
      return Future.value(null);
    }

    globals.logger.d(request);

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
    if (url == "$backendUrl/auth/logout") {
      _token = Future.value(null);
      notifyListeners();
      _storeToken(null);
      return super.post(url, headers: headers, body: body, encoding: encoding);
    }
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

  String _storeToken(String token) {
    if (token == null) {
      _storage.delete(key: 'token');
    } else {
      _storage.write(key: 'token', value: token);
    }
    return token;
  }

  void login(String username, String password) {
    final body = json.encode({'username': username, 'password': password});
    _token = post("$backendUrl/auth/login", body: body, headers: headers)
        .then((response) {
      if (response.statusCode == 200) {
        return json.decode(response.body)["token"];
      }
      return null;
    }).then((value) => _storeToken(value));
    notifyListeners();
  }

  Future<bool> loggedIn() {
    return _token.then((token) {
      return token != null;
    });
  }

  void logOut() {
    post("$backendUrl/auth/logout");
  }
}
