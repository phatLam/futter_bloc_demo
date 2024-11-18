import 'dart:async';

import 'package:authentication_repo/src/authentication_repo_base.dart';
import 'package:bloc/bloc.dart';
import 'package:demo2/login/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthenticationRepo authenticationRepo})
      :_authenticationRepo = authenticationRepo,
        super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginUserNameChanged>(_onUsernameChanged);
  }

  final AuthenticationRepo _authenticationRepo;

  FutureOr<void> _onSubmitted(LoginSubmitted event,
      Emitter<LoginState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
    await _authenticationRepo.login(userName: state.username.value, password: state.password.value);
    emit(state.copyWith(status: FormzSubmissionStatus.success));
  }catch(_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  }

  FutureOr<void> _onPasswordChanged(LoginPasswordChanged event,
      Emitter<LoginState> emit) {
    final password = Password.dirty(event.password);
    emit(
        state.copyWith(
            password: password,
            isValid: Formz.validate([state.username, password])
        )
    );
  }

  FutureOr<void> _onUsernameChanged(LoginUserNameChanged event,
      Emitter<LoginState> emit) {
    final username = Username.dirty(event.userName);
    emit(
        state.copyWith(
            username: username,
            isValid: Formz.validate([username, state.password])
        )
    );
  }
}
