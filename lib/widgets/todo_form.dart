import 'package:enum_to_string/enum_to_string.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:open_todos_flutter_frontend/api/api_service.dart';
import 'package:open_todos_flutter_frontend/api/todo.dart';
import 'package:open_todos_flutter_frontend/widgets/login_screen_builder.dart';

class TodoForm extends StatefulWidget {
  final Function callback;
  final Todo todo;

  TodoForm(this.callback, this.todo);

  @override
  _TodoFormState createState() => new _TodoFormState();

  static TodoForm pushOnContext(context, callback, todo) {
    final todoForm = TodoForm(callback, todo);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => todoForm));
    return todoForm;
  }
}

class _TodoFormState extends State<TodoForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _nameKey =
      new GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _descriptionKey =
      new GlobalKey<FormFieldState<String>>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
    final apiService = context.watch<APIService>();
    return LoginScreenBuilder(
        builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(
                    widget.todo.isPersisted() ? 'Update Todo' : 'Create Todo'),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    final todo = widget.todo;
                    todo.name = _nameKey.currentState.value;
                    todo.description = _descriptionKey.currentState.value;
                    todo.state = statusValue;

                    await todo.save(apiService);
                    Navigator.pop(context);
                    this.widget.callback();
                  }
                },
                child: Icon(widget.todo.isPersisted() ? Icons.edit : Icons.add),
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
                          autofocus: true,
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
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
