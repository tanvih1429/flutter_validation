/// Chainable validation rules for email values.
class EmailValidationSupport {
  final String _value;
  String? _error;

  /// Creates an email validator for the provided value.
  EmailValidationSupport(this._value);

  /// Fails when the email is empty or contains only whitespace.
  EmailValidationSupport isRequired({String? message}) {
    if (_value.trim().isEmpty) {
      _error ??= message ??= "Email is required";
    }
    return this;
  }

  /// Fails when the value is not in a basic email format.
  EmailValidationSupport isValidEmail({String? message}) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(_value)) {
      _error ??= message ??= "Invalid email";
    }
    return this;
  }

  /// Fails when the email contains spaces.
  EmailValidationSupport noSpaces({String? message}) {
    if (_value.contains(" ")) {
      _error ??= message ??= "Email should not contain spaces";
    }
    return this;
  }

  /// Fails when the email does not contain an `@` symbol.
  EmailValidationSupport hasAtSymbol({String? message}) {
    if (!_value.contains("@")) {
      _error ??= message ??= "Email must contain @";
    }
    return this;
  }

  /// Fails when the email does not end with one of the allowed [domains].
  EmailValidationSupport allowDomain(List<String> domains, {String? message}) {
    bool isValid = domains.any((domain) => _value.endsWith(domain));

    if (!isValid) {
      String allowed = domains.join(', ');
      _error ??= message ??=
          "Email must be from one of these domains: $allowed";
    }

    return this;
  }

  /// Fails when the email is shorter than [length].
  EmailValidationSupport minLength(int length, {String? message}) {
    if (_value.length < length) {
      _error ??= message ??= "Email must be at least $length characters";
    }
    return this;
  }

  /// Fails when the email is longer than [length].
  EmailValidationSupport maxLength(int length, {String? message}) {
    if (_value.length > length) {
      _error ??= message ??= "Email must be less than $length characters";
    }
    return this;
  }

  /// Fails when the email contains more than one `@` symbol.
  EmailValidationSupport singleAtSymbol({String? message}) {
    if ("@".allMatches(_value).length > 1) {
      _error ??= message ??= "Email cannot contain multiple @";
    }
    return this;
  }

  /// Fails when the email starts with a dot.
  EmailValidationSupport noStartingDot({String? message}) {
    if (_value.startsWith(".")) {
      _error ??= message ??= "Email cannot start with dot";
    }
    return this;
  }

  /// Fails when the email ends with a dot.
  EmailValidationSupport noEndingDot({String? message}) {
    if (_value.endsWith(".")) {
      _error ??= message ??= "Email cannot end with dot";
    }
    return this;
  }

  /// Fails when the email contains consecutive dots.
  EmailValidationSupport noConsecutiveDots({String? message}) {
    if (_value.contains("..")) {
      _error ??= message ??= "Email cannot contain consecutive dots";
    }
    return this;
  }

  /// Applies a custom [validator] and stores [message] when it fails.
  EmailValidationSupport custom(
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
