import 'package:flutter/material.dart';

import 'todo.dart';
import 'todo_form.dart';
import 'todo_table.dart';

void main() => runApp(OpenTODOs());

class OpenTODOs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOs',
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        accentColor: Colors.blue,
      ),
      home: MyHomePage(title: 'TODOs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: TodoTable()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TodoForm()));
        },
        tooltip: 'Create TODO',
        child: Icon(Icons.add),
      ),
    );
  }
}
