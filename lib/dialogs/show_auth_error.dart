import 'package:fluter_bloc_app/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

import '../services/auth/auth.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogContent,
    optionsBuilder: () => {
      'OK': true,
    },
  );
}
