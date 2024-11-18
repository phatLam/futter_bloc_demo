
import 'package:formz/formz.dart';

enum UsernameValidationError{empty}

class Username extends FormzInput<String, UsernameValidationError> {
  // Call super.pure to represent an unmodified form input.
  const Username.pure(): super.pure('');
  // Call super.dirty to represent a modified form input.
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    if(value.isEmpty) return UsernameValidationError.empty;
    return null;
  }
}
