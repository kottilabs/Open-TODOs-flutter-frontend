import 'package:flutter/material.dart';
import 'package:open_todos_flutter_frontend/login_screen_builder.dart';
import 'package:provider/provider.dart';

import 'package:open_todos_flutter_frontend/api_service.dart';
import 'package:open_todos_flutter_frontend/api/scope.dart';

class ScopeForm extends StatefulWidget {
  final Function callback;
  final Scope scope;

  ScopeForm(this.callback, this.scope);

  @override
  _ScopeFormState createState() => _ScopeFormState();

  static ScopeForm pushOnContext(context, callback, scope) {
    final scopeForm = ScopeForm(callback, scope);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => scopeForm));
    return scopeForm;
  }
}

class _ScopeFormState extends State<ScopeForm> {
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> _nameKey =
      new GlobalKey<FormFieldState<String>>();

  static final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.scope.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.watch<APIService>();
    return LoginScreenBuilder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.scope.isPersisted() ? 'Update Scope' : 'Create Scope'),
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
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a name';
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
                            final scope = widget.scope;
                            scope.name = _nameKey.currentState.value;

                            await scope.save(apiService);
                            Navigator.pop(context);
                            this.widget.callback();
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
    });
  }
}
