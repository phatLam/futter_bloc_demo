import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepo {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {}

  Future<void> login({
    required String userName,
    required String password,
  }) async {
    await Future.delayed(Duration(milliseconds: 300),
        () => _controller.add(AuthenticationStatus.authenticated));
  }

  void logout() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() {
    _controller.close();
  }
}
