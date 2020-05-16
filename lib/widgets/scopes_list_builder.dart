import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:open_todos_flutter_frontend/api/scopes.dart';
import 'package:open_todos_flutter_frontend/widgets/scopes_list.dart';

class ScopesListBuilder extends Builder {
  const ScopesListBuilder({
    Key key,
    builder,
  }) : super(key: key, builder: builder);

  @override
  Widget build(BuildContext context) {
    if (context.watch<Scopes>().scope == null) {
      return ScopesList();
    }
    return builder(context);
  }
}
