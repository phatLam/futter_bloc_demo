import 'dart:async';

import 'package:authentication_repo/authentication_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repo/user_repo.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
      {required this.authenticationRepository, required this.userRepository})
      : super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
  }

  final AuthenticationRepo authenticationRepository;
  final UserRepo userRepository;

  FutureOr<void> _onSubscriptionRequested(
      AuthenticationSubscriptionRequested event,
      Emitter<AuthenticationState> emit) async{
      return emit.onEach(stream, onData: onData)
  }

  FutureOr<void> _onLogoutPressed(
      AuthenticationLogoutPressed event, Emitter<AuthenticationState> emit) {
      authenticationRepository.logout();
  }
}
