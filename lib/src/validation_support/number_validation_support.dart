/// Chainable validation rules for numeric string values.
class NumberValidationSupport {
  final String _value;
  String? _error;

  /// Creates a number validator for the provided value.
  NumberValidationSupport(String value) : _value = value;

  /// Fails when the value is empty or contains only whitespace.
  NumberValidationSupport isRequired({String? message}) {
    if (_value.trim().isEmpty) {
      _error ??= message ?? "Number is required";
    }
    return this;
  }

  /// Fails when the value contains characters other than digits.
  NumberValidationSupport digitsOnly({String? message}) {
    if (!RegExp(r'^\d+$').hasMatch(_value)) {
      _error ??= message ?? "Only digits are allowed";
    }
    return this;
  }

  /// Fails when the value length is shorter than [length].
  NumberValidationSupport minLength(int length, {String? message}) {
    if (_value.length < length) {
      _error ??= message ?? "Must be at least $length digits";
    }
    return this;
  }

  /// Fails when the value length is longer than [length].
  NumberValidationSupport maxLength(int length, {String? message}) {
    if (_value.length > length) {
      _error ??= message ?? "Must be less than $length digits";
    }
    return this;
  }

  /// Fails when the value length is not exactly [length].
  NumberValidationSupport exactLength(int length, {String? message}) {
    if (_value.length != length) {
      _error ??= message ?? "Must be exactly $length digits";
    }
    return this;
  }

  /// Fails when the parsed number is lower than [min].
  NumberValidationSupport minValue(num min, {String? message}) {
    final number = num.tryParse(_value);
    if (number == null || number < min) {
      _error ??= message ?? "Value must be at least $min";
    }
    return this;
  }

  /// Fails when the parsed number is greater than [max].
  NumberValidationSupport maxValue(num max, {String? message}) {
    final number = num.tryParse(_value);
    if (number == null || number > max) {
      _error ??= message ?? "Value must be less than or equal to $max";
    }
    return this;
  }

  /// Fails when the parsed number is outside the inclusive range.
  NumberValidationSupport inRange(num min, num max, {String? message}) {
    final number = num.tryParse(_value);
    if (number == null || number < min || number > max) {
      _error ??= message ?? "Value must be between $min and $max";
    }
    return this;
  }

  /// Fails when the value is not a valid integer.
  NumberValidationSupport isInteger({String? message}) {
    if (!RegExp(r'^-?\d+$').hasMatch(_value)) {
      _error ??= message ?? "Value must be an integer";
    }
    return this;
  }

  /// Fails when the parsed number is not greater than zero.
  NumberValidationSupport isPositive({String? message}) {
    final number = num.tryParse(_value);
    if (number == null || number <= 0) {
      _error ??= message ?? "Value must be greater than 0";
    }
    return this;
  }

  /// Fails when the value contains spaces.
  NumberValidationSupport noSpaces({String? message}) {
    if (_value.contains(' ')) {
      _error ??= message ?? "Spaces are not allowed";
    }
    return this;
  }

  /// Applies a custom [validator] and stores [message] when it fails.
  NumberValidationSupport custom(
    bool Function(String value) validator, {
    String message = "Number is invalid",
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
