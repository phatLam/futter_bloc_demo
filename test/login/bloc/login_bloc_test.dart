import 'package:authentication_repo/authentication_repo.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:demo2/login/bloc/login_bloc.dart';
import 'package:demo2/login/models/password.dart';
import 'package:demo2/login/models/username.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';

void main() {
  group(LoginBloc, (){
    late LoginBloc loginBloc;
    setUp((){
      loginBloc = LoginBloc(authenticationRepo: AuthenticationRepo());
    });
    blocTest("description",
    build: () => loginBloc,
    act: (bloc) => bloc.add(const LoginUserNameChanged("haha")),
    expect: () =>  [const LoginState(
        status: FormzSubmissionStatus.initial,
        username: Username.dirty("haha"),
        password: Password.pure(),
        isValid: false
    ),]);
  });
}
