import 'package:demo2/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [_UserId(), LogoutButton()],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          context.read<AuthenticationBloc>().add(AuthenticationLogoutPressed());
        },
        child: const Text('Logout'));
  }
}

class _UserId extends StatelessWidget {
  const _UserId({super.key});

  @override
  Widget build(BuildContext context) {
    //this line will trigger updates if the user id changes.
    final userId =
        context.select((AuthenticationBloc bloc) => bloc.state.user.id);
    return Text('userID: $userId ');
  }
}
