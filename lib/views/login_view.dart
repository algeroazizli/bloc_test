import 'package:fluter_bloc_app/bloc/app_bloc.dart';
import 'package:fluter_bloc_app/bloc/app_event.dart';
import 'package:fluter_bloc_app/extensions/if_debugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = useTextEditingController(
      text: "ibragim.abdulazizli@gmail.com".ifDebugging,
    );
    final passCtrl = useTextEditingController(
      text: "123456blabla".ifDebugging,
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Log in",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.dark,
                controller: emailCtrl,
                decoration: const InputDecoration(
                  hintText: "Enter your email",
                  labelText: "Email",
                ),
              ),
              TextField(
                obscureText: true,
                obscuringCharacter: "*",
                keyboardAppearance: Brightness.dark,
                controller: passCtrl,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  final email = emailCtrl.text;
                  final password = passCtrl.text;
                  context.read<AppBloc>().add(
                        AppEventLogin(
                          email: email,
                          password: password,
                        ),
                      );
                },
                child: const Text("Log in"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AppBloc>().add(
                        const AppEventGoToRegister(),
                      );
                },
                child: const Text(
                  "Not registered? Sign up",
                ),
              ),
            ],
          ),
        ));
  }
}
