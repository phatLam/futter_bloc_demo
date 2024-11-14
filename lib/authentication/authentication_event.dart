part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

class AuthenticationSubscriptionRequested extends AuthenticationEvent {}

class AuthenticationLogoutPressed extends AuthenticationEvent {}
