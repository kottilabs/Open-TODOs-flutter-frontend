import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:open_todos_flutter_frontend/api/api_service.dart';
import 'package:open_todos_flutter_frontend/widgets/login_screen.dart';

class LoginScreenBuilder extends Builder {
  const LoginScreenBuilder({
    Key key,
    builder,
  })  : assert(builder != null),
        super(key: key, builder: builder);

  @override
  Widget build(BuildContext context) {
    final service = context.watch<APIService>();
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data) {
            return builder(context);
          }
          return LoginScreen();
        },
        future: service.loggedIn());
  }
}
