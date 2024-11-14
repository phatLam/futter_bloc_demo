import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;

  User(this.id);

  static var empty = User("-");

  @override
  List<Object?> get props => [id];
}
