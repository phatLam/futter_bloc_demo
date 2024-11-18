import 'package:authentication_repo/authentication_repo.dart';
import 'package:demo2/login/bloc/login_bloc.dart';
import 'package:demo2/login/view/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) =>
              LoginBloc(authenticationRepo: context.read<AuthenticationRepo>()),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
