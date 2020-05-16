import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:open_todos_flutter_frontend/api/api_service.dart';

class LoginScreenBuilder extends Builder {
  const LoginScreenBuilder({
    Key key,
    builder,
  }) : super(key: key, builder: builder);

  @override
  Widget build(BuildContext context) {
    context.watch<APIService>().loggedIn().then((loggedIn) {
      if (!loggedIn) {
        Navigator.popUntil(context, ModalRoute.withName('/login'));
      }
    });
    return builder(context);
  }
}
