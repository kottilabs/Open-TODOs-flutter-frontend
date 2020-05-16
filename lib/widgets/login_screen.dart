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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
      floatingActionButton: FutureBuilder(
        future: apiService.loggedIn().then((loggedIn) {
          if (loggedIn) {
            _nameController.text = _passwordController.text = '';
            Navigator.pushNamed(context, '/todos');
          }
          return loggedIn;
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.none &&
              snapshot.connectionState != ConnectionState.done) {
            return FloatingActionButton(
              onPressed: null,
              child: CircularProgressIndicator(),
            );
          }
          return buildContinueFloatingActionButton(apiService);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container(), flex: 309),
            Divider(),
            Expanded(child: loginForm(), flex: 191),
          ],
        ),
      ),
    );
  }

  FloatingActionButton buildContinueFloatingActionButton(
      APIService apiService) {
    return FloatingActionButton(
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
            controller: _nameController,
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
            controller: _passwordController,
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
