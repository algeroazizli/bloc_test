import 'package:fluter_bloc_app/bloc/app_event.dart';
import 'package:fluter_bloc_app/dialogs/delete_account_dialog.dart';
import 'package:fluter_bloc_app/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_bloc.dart';

enum MenuAction {
  logout,
  deleteAccunt,
}

class MainMenuPopUpButton extends StatelessWidget {
  const MainMenuPopUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>();

    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogOut = await showLogOutDialog(context);
            if (shouldLogOut) {
              appBloc.add(
                const AppEventLogOut(),
              );
            }
            break;
          case MenuAction.deleteAccunt:
            final shouldDeleteAccount = await showDeleteAccountDialog(context);
            if (shouldDeleteAccount) {
              appBloc.add(
                const AppEventDeleteAccount(),
              );
            }
            break;
        }
      },
      itemBuilder: (context) {
        return const [
          PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text("Logout"),
          ),
          PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccunt,
            child: Text("Delete account"),
          ),
        ];
      },
    );
  }
}
