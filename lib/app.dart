import 'package:demo2/authentication/authentication_bloc.dart';
import 'package:demo2/splash/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
///
/// AppView is a StatefulWidget because it maintains a GlobalKey which is used to access the NavigatorState
///
class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        //uses BlocListener to navigate to different pages based on changes in the AuthenticationState.
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch(state) {
              case AuthenticationStatus
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_)=> SplashPage.route(),
    );
  }
}
