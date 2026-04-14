/// Chainable validation rules for confirm-password fields.
class ConfirmPasswordValidationSupport {
  final String _password;
  final String _confirmPassword;
  String? _error;

  /// Creates a confirm-password validator for the provided values.
  ConfirmPasswordValidationSupport({
    required String password,
    required String confirmPassword,
  }) : _password = password,
       _confirmPassword = confirmPassword;

  /// Fails when the confirm password value is empty.
  ConfirmPasswordValidationSupport isRequired({String? message}) {
    if (_confirmPassword.trim().isEmpty) {
      _error ??= message ?? "Confirm password is required";
    }
    return this;
  }

  /// Fails when the confirm password does not match the original password.
  ConfirmPasswordValidationSupport matchesPassword({String? message}) {
    if (_password != _confirmPassword) {
      _error ??= message ?? "Passwords do not match";
    }
    return this;
  }

  /// Applies a custom [validator] and stores [message] when it fails.
  ConfirmPasswordValidationSupport custom(
    bool Function(String password, String confirmPassword) validator, {
    String message = "Confirm password is invalid",
  }) {
    if (_error != null) return this;

    if (!validator(_password, _confirmPassword)) {
      _error = message;
    }
    return this;
  }

  /// Returns the first validation error, or `null` if all rules passed.
  String? validate() {
    return _error;
  }
}
