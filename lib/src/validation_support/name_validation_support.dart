/// Chainable validation rules for person or display names.
class NameValidationSupport {
  final String _value;
  String? _error;

  /// Creates a name validator for the provided value.
  NameValidationSupport(String value) : _value = value;

  /// Fails when the name is empty or contains only whitespace.
  NameValidationSupport isRequired({String? message}) {
    if (_value.trim().isEmpty) {
      _error ??= message ?? "Name is required";
    }
    return this;
  }

  /// Fails when the trimmed name is shorter than [length].
  NameValidationSupport minLength(int length, {String? message}) {
    if (_value.trim().length < length) {
      _error ??= message ?? "Name must be at least $length characters";
    }
    return this;
  }

  /// Fails when the trimmed name is longer than [length].
  NameValidationSupport maxLength(int length, {String? message}) {
    if (_value.trim().length > length) {
      _error ??= message ?? "Name must be less than $length characters";
    }
    return this;
  }

  /// Fails when the name contains numeric digits.
  NameValidationSupport noNumbers({String? message}) {
    if (RegExp(r'[0-9]').hasMatch(_value)) {
      _error ??= message ?? "Name should not contain numbers";
    }
    return this;
  }

  /// Fails when the name contains special characters.
  NameValidationSupport noSpecialCharacters({String? message}) {
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(_value)) {
      _error ??= message ?? "Name should not contain special characters";
    }
    return this;
  }

  /// Fails when the name contains repeated internal spaces.
  NameValidationSupport noExtraSpaces({String? message}) {
    if (_value.contains(RegExp(r'\s{2,}'))) {
      _error ??= message ?? "Name should not contain multiple spaces";
    }
    return this;
  }

  /// Fails when the trimmed name does not begin with a letter.
  NameValidationSupport startsWithLetter({String? message}) {
    if (!RegExp(r'^[a-zA-Z]').hasMatch(_value.trim())) {
      _error ??= message ?? "Name must start with a letter";
    }
    return this;
  }

  /// Fails when the value does not appear to contain a full name.
  NameValidationSupport isFullName({String? message}) {
    final parts = _value.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) {
      _error ??= message ?? "Please enter full name";
    }
    return this;
  }

  /// Applies a custom [validator] and stores [message] when it fails.
  NameValidationSupport custom(
    bool Function(String value) validator, {
    String message = "Name is invalid",
  }) {
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
