import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_todos_flutter_frontend/api/scopes.dart';
import 'package:open_todos_flutter_frontend/api/scope.dart';
import 'package:open_todos_flutter_frontend/widgets/todos_list.dart';
import 'package:open_todos_flutter_frontend/widgets/login_screen_builder.dart';
import 'package:open_todos_flutter_frontend/widgets/scope_form.dart';
import 'package:open_todos_flutter_frontend/widgets/todo_drawer.dart';

class ScopesList extends StatefulWidget {
  @override
  _ScopesListState createState() => _ScopesListState();
}

class _ScopesListState extends State<ScopesList> {
  Future<List<Scope>> _futureScopes;

  Future<List<Scope>> fetchAndSetScopes(Scopes scopes) {
    setState(() {
      _futureScopes = scopes.fetchScopes();
    });
    return _futureScopes;
  }

  @override
  Widget build(BuildContext context) {
    final scopes = context.watch<Scopes>();
    if (_futureScopes == null) {
      _futureScopes = scopes.fetchScopes();
    }
    return LoginScreenBuilder(
        builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Scopes'),
              ),
              drawer: TodoDrawer(),
              body: Center(
                  child: FutureBuilder<List<Scope>>(
                      future: _futureScopes,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        } else if (snapshot.hasData) {
                          return snapshot.data.length > 0
                              ? RefreshIndicator(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView(
                                        children: _getScopeWidgets(
                                            snapshot.data, scopes)),
                                  ),
                                  onRefresh: () => fetchAndSetScopes(scopes))
                              : _getNoScopes();
                        }
                        return CircularProgressIndicator();
                      })),
              floatingActionButton: FloatingActionButton(
                onPressed: () => ScopeForm.pushOnContext(
                    context, (scope) => scopes.setScope(scope), Scope(null)),
                tooltip: 'Create Scope',
                child: Icon(Icons.add),
              ),
            ));
  }

  List<Widget> _getScopeWidgets(List<Scope> scopeList, Scopes scopes) {
    var widgets = List<Widget>();
    scopeList.forEach((scope) {
      widgets.add(ListTile(
        title: Text(scope.name),
        onTap: () {
          scopes.setScope(scope);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => TodosList(),
          ));
        },
      ));
      widgets.add(Divider(color: Theme.of(context).accentColor));
    });
    return widgets;
  }

  Widget _getNoScopes() {
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text('Nothing here... Create a Scope!'));
  }
}
