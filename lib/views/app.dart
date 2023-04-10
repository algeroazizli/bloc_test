import 'package:fluter_bloc_app/bloc/app_bloc.dart';
import 'package:fluter_bloc_app/bloc/app_event.dart';
import 'package:fluter_bloc_app/dialogs/show_auth_error.dart';
import 'package:fluter_bloc_app/views/login_view.dart';
import 'package:fluter_bloc_app/views/photo_gallery_view.dart';
import 'package:fluter_bloc_app/views/reegister_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_state.dart';
import '../loading/loading_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: "Bloc Test App",
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AppBloc, AppState>(listener: (context, appState) {
          if (appState.isLoading) {
            LoadingScreen.instance().show(
              context: context,
              text: "Loading...",
            );
          } else {
            LoadingScreen.instance().hide();
          }
          final authError = appState.authError;
          if (authError != null) {
            showAuthError(
              authError: authError,
              context: context,
            );
          }
        }, builder: (context, appState) {
          if (appState is AppStateLoggedOut) {
            return const LoginView();
          } else if (appState is AppStateLoggedIn) {
            return const PhotoGalleryView();
          } else if (appState is AppStateIsInRegisterView) {
            return const RegisterView();
          }
          return Container();
        }),
      ),
    );
  }
}
