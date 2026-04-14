/// Chainable validation rules for contact number values.
class ContactValidationSupport {
  final String _value;
  String? _error;

  /// Creates a contact number validator for the provided value.
  ContactValidationSupport(this._value);

  /// Fails when the contact number is empty or contains only whitespace.
  ContactValidationSupport isRequired({String? message}) {
    if (_value.trim().isEmpty) {
      _error ??= message ??= "Contact number is required";
    }
    return this;
  }

  /// Fails when the contact number contains invalid non-numeric characters.
  ContactValidationSupport isNumeric({bool allowPlus = true, String? message}) {
    // Allows only digits, and optionally a leading '+'
    final regex = allowPlus ? RegExp(r'^\+?[0-9]+$') : RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(_value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      _error ??= message ??= "Contact number must contain only valid digits";
    }
    return this;
  }

  /// Fails when the number is not in strict E.164 format.
  ContactValidationSupport isE164Format({String? message}) {
    // Strict E.164 format: Starts with '+', followed by 1 to 14 digits. No spaces.
    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    if (!regex.hasMatch(_value)) {
      _error ??= message ??=
          "Number must be in E.164 format (e.g., +1234567890)";
    }
    return this;
  }

  /// Fails when the number does not match a general phone format.
  ContactValidationSupport isValidGeneralFormat({String? message}) {
    // Permissive regex that allows +, spaces, brackets, and dashes
    final regex = RegExp(
      r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$',
    );
    if (!regex.hasMatch(_value)) {
      _error ??= message ??= "Invalid contact number format";
    }
    return this;
  }

  /// Fails when the number is not a valid Indian mobile number.
  ContactValidationSupport isIndianNumber({String? message}) {
    // Validates Indian numbers with optional +91, spaces, or hyphens
    final regex = RegExp(r'^(?:\+91[\-\s]?)?[6789]\d{9}$');
    if (!regex.hasMatch(_value)) {
      _error ??= message ??= "Invalid Indian contact number";
    }
    return this;
  }

  /// Fails when the number is not a valid US or Canada number.
  ContactValidationSupport isUSNumber({String? message}) {
    // Validates US/Canada numbers (NANP) with various formatting
    final regex = RegExp(
      r'^(?:\+?1[\-\s]?)?(?:\([2-9]\d{2}\)|[2-9]\d{2})[\-\s]?[2-9]\d{2}[\-\s]?\d{4}$',
    );
    if (!regex.hasMatch(_value)) {
      _error ??= message ??= "Invalid US/Canada contact number";
    }
    return this;
  }

  /// Fails when the cleaned number has fewer than [length] digits.
  ContactValidationSupport minLength(int length, {String? message}) {
    // Strips common formatting to check the actual digit count
    final cleanLength = _value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '').length;
    if (cleanLength < length) {
      _error ??= message ??= "Contact number must have at least $length digits";
    }
    return this;
  }

  /// Fails when the cleaned number has more than [length] digits.
  ContactValidationSupport maxLength(int length, {String? message}) {
    // Strips common formatting to check the actual digit count
    final cleanLength = _value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '').length;
    if (cleanLength > length) {
      _error ??= message ??= "Contact number must not exceed $length digits";
    }
    return this;
  }

  /// Applies a custom [validator] and stores [message] when it fails.
  ContactValidationSupport custom(
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
