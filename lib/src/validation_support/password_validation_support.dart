/// Chainable validation rules for password values.
class PasswordValidationSupport {
  final String _value;
  String? _error;

  /// Creates a password validator for the provided value.
  PasswordValidationSupport(String value) : _value = value;

  /// Fails when the password is empty or contains only whitespace.
  PasswordValidationSupport isRequired({String? message}) {
    if (_value.trim().isEmpty) {
      _error ??= message ?? "Password is required";
    }
    return this;
  }

  /// Fails when the password is shorter than [length].
  PasswordValidationSupport minLength(int length, {String? message}) {
    if (_value.length < length) {
      _error ??= message ?? "Password must be at least $length characters";
    }
    return this;
  }

  /// Fails when the password is longer than [length].
  PasswordValidationSupport maxLength(int length, {String? message}) {
    if (_value.length > length) {
      _error ??= message ?? "Password must be less than $length characters";
    }
    return this;
  }

  /// Fails when the password does not contain an uppercase letter.
  PasswordValidationSupport hasUppercase({String? message}) {
    if (!RegExp(r'[A-Z]').hasMatch(_value)) {
      _error ??=
          message ?? "Password must contain at least one uppercase letter";
    }
    return this;
  }

  /// Fails when the password does not contain a lowercase letter.
  PasswordValidationSupport hasLowercase({String? message}) {
    if (!RegExp(r'[a-z]').hasMatch(_value)) {
      _error ??=
          message ?? "Password must contain at least one lowercase letter";
    }
    return this;
  }

  /// Fails when the password does not contain a numeric digit.
  PasswordValidationSupport hasNumber({String? message}) {
    if (!RegExp(r'[0-9]').hasMatch(_value)) {
      _error ??= message ?? "Password must contain at least one number";
    }
    return this;
  }

  /// Fails when the password does not contain a special character.
  PasswordValidationSupport hasSpecialCharacter({String? message}) {
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]=+;]').hasMatch(_value)) {
      _error ??=
          message ?? "Password must contain at least one special character";
    }
    return this;
  }

  /// Fails when the password contains spaces.
  PasswordValidationSupport noSpaces({String? message}) {
    if (_value.contains(' ')) {
      _error ??= message ?? "Password should not contain spaces";
    }
    return this;
  }

  /// Applies a custom [validator] and stores [message] when it fails.
  PasswordValidationSupport custom(
    bool Function(String value) validator,
    String message,
  ) {
    if (_error != null) return this;

    if (!validator(_value)) {
      _error = message;
    }
    return this;
  }

  /// Returns the first validation error, or `null` if all rules passed.
  String? validate() {
    return _error;
  }
}
