import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoForm extends StatefulWidget {
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
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
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    _openTodoStatePicker(context);
                  },
                  child: Text('a'),
                  color: Colors.white,
                  textColor: Theme.of(context).accentColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          // Process data.
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
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoActionSheet(
            message: Text('Choose the status'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text("A"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ));
      },
    ).then<void>((value) {});
  }
}