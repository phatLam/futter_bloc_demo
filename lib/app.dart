import 'package:authentication_repo/authentication_repo.dart';
import 'package:demo2/authentication/authentication_bloc.dart';
import 'package:demo2/home/view/home_page.dart';
import 'package:demo2/login/view/login_page.dart';
import 'package:demo2/splash/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repo/user_repo.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepo _authenticationRepo;
  late final UserRepo _userRepo;

  @override
  void initState() {
    super.initState();
    _authenticationRepo = AuthenticationRepo();
    _userRepo = UserRepo();
  }

  @override
  void dispose() {
    _authenticationRepo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepo,
      child: BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
            authenticationRepository: _authenticationRepo,
            userRepository: _userRepo)
          ..add(AuthenticationSubscriptionRequested()),
        child: const AppView(),
      ),
    );
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
            switch (state.status) {
              case AuthenticationStatus.unknown:
                break;
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil(
                    HomePage.route(), (route) => false);
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil(
                  LoginPage.route(),
                  (route) => false,
                );
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
