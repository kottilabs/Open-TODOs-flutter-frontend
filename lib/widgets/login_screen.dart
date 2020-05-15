import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_todos_flutter_frontend/api/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _passwordFocus;

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormFieldState<String>> _nameKey =
      new GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _passwordKey =
      new GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Login'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_nameKey.currentState.validate()) {
            return;
          }
          if (_passwordKey.currentState.value.isEmpty) {
            _passwordFocus.requestFocus();
            return;
          }

          if (_formKey.currentState.validate()) {
            apiService.login(
                _nameKey.currentState.value, _passwordKey.currentState.value);
          }
        },
        child: Icon(Icons.navigate_next),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: loginForm(),
          ),
          Text('x'),
        ],
      ),
    );
  }

  Form loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            key: _nameKey,
            decoration: const InputDecoration(
              hintText: 'Username',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
          ),
          TextFormField(
            focusNode: _passwordFocus,
            obscureText: true,
            key: _passwordKey,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
