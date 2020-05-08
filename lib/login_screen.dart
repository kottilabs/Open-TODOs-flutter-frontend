import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_todos_flutter_frontend/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormFieldState<String>> _nameKey =
      new GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _passwordKey =
      new GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
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
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          apiService.login(_nameKey.currentState.value,
                              _passwordKey.currentState.value);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
