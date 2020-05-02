import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'todo.dart';

class TodoForm extends StatelessWidget {

  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> _nameKey = new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _descriptionKey = new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _stateKey = new GlobalKey<FormFieldState<String>>();

  var _stateController = TextEditingController(text: EnumToString.parse(Status.TODO));
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create TODO'),
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
                    hintText: 'Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  key: _descriptionKey,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                ),
                TextFormField(
                  controller: _stateController,
                  key: _stateKey,
                  decoration: const InputDecoration(
                    hintText: 'State',
                  ),
                  readOnly: true,
                  onTap: () {
                    _openTodoStatePicker(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          final name = _nameKey.currentState.value;
                          final description = _descriptionKey.currentState.value;
                          final state = _stateKey.currentState.value;
                          Navigator.pop(context);
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


  _openTodoStatePicker(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoActionSheet(
            message: Text('Choose the status'),
            actions: (Status.values.map((status) => CupertinoActionSheetAction(
              child: Text(EnumToString.parse(status)),
              onPressed: () {
                Navigator.of(context).pop(EnumToString.parse(status));
              },
            )).toList()),
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ));
      },
    ).then<void>((String value) {
      _stateController.text = value;
    });
  }
}