import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:basic_utils/basic_utils.dart';

import 'api/todo.dart';

class TodoForm extends StatefulWidget {
  final Function callback;
  final Todo todo;

  TodoForm(this.callback, this.todo);

  @override
  _TodoFormState createState() => new _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> _nameKey =
      new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _descriptionKey =
      new GlobalKey<FormFieldState<String>>();

  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _descriptionController =
      TextEditingController();

  Status statusValue;

  @override
  void initState() {
    _nameController.text = widget.todo.name;
    _descriptionController.text = widget.todo.description;
    statusValue = widget.todo.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo'),
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
                TextFormField(
                  key: _descriptionKey,
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                ),
                DropdownButton(
                  iconSize: 48,
                  underline: Container(
                    height: 1,
                    color: Theme.of(context).disabledColor,
                  ),
                  isExpanded: true,
                  onChanged: (Status newValue) {
                    setState(() {
                      statusValue = newValue;
                    });
                  },
                  value: statusValue,
                  items: Status.values
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(StringUtils.capitalize(
                                EnumToString.parse(status))),
                          ))
                      .toList(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          final todo = widget.todo;
                          todo.name = _nameKey.currentState.value;
                          todo.description = _descriptionKey.currentState.value;
                          todo.state = statusValue;

                          await todo.save();
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
  }
}
