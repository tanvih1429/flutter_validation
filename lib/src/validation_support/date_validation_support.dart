import 'package:intl/intl.dart';

/// Chainable validation rules for date values.
class DateValidationSupport {
  final String _value;
  String? _error;

  /// Creates a date validator for the provided value.
  DateValidationSupport(this._value);

  /// Fails when the value is empty or contains only whitespace.
  DateValidationSupport required({String? message}) {
    if (_error != null) return this;

    if (_value.trim().isEmpty) {
      _error = message ?? "Field is required";
    }
    return this;
  }

  /// Fails when the value does not match one or more allowed date formats.
  DateValidationSupport dateFormat(dynamic formats, {String? message}) {
    if (_error != null) return this;

    final formatList = formats is List<String> ? formats : [formats];

    bool isValid = false;

    for (var format in formatList) {
      try {
        DateFormat(format).parseStrict(_value);
        isValid = true;
        break;
      } catch (_) {}
    }

    if (!isValid) {
      _error = message ?? "Invalid date format";
    }

    return this;
  }

  /// Parses the current value into a [DateTime] when possible.
  DateTime? _parseDate() {
    try {
      return DateTime.tryParse(_value);
    } catch (_) {
      return null;
    }
  }

  /// Fails when the date is not before the current date and time.
  DateValidationSupport pastDate({String? message}) {
    if (_error != null) return this;

    final date = _parseDate();

    if (date == null || !date.isBefore(DateTime.now())) {
      _error = message ?? "Date must be in the past";
    }

    return this;
  }

  /// Fails when the date is not after the current date and time.
  DateValidationSupport futureDate({String? message}) {
    if (_error != null) return this;

    final date = _parseDate();

    if (date == null || !date.isAfter(DateTime.now())) {
      _error = message ?? "Date must be in the future";
    }

    return this;
  }

  /// Fails when the date is outside the inclusive [min] and [max] range.
  DateValidationSupport dateRange({
    required DateTime min,
    required DateTime max,
    String? message,
  }) {
    if (_error != null) return this;

    final date = _parseDate();

    if (date == null || date.isBefore(min) || date.isAfter(max)) {
      _error = message ?? "Date out of range";
    }

    return this;
  }

  /// Fails when the value represents an age younger than [age].
  DateValidationSupport minAge(int age, {String? message}) {
    if (_error != null) return this;

    final date = _parseDate();

    if (date == null) {
      _error = message ?? "Invalid date";
      return this;
    }

    final today = DateTime.now();
    int calculatedAge = today.year - date.year;

    if (today.month < date.month ||
        (today.month == date.month && today.day < date.day)) {
      calculatedAge--;
    }

    if (calculatedAge < age) {
      _error = message ?? "Minimum age is $age";
    }

    return this;
  }

  /// Fails when the value represents an age older than [age].
  DateValidationSupport maxAge(int age, {String? message}) {
    if (_error != null) return this;

    final date = _parseDate();

    if (date == null) {
      _error = message ?? "Invalid date";
      return this;
    }

    final today = DateTime.now();
    int calculatedAge = today.year - date.year;

    if (today.month < date.month ||
        (today.month == date.month && today.day < date.day)) {
      calculatedAge--;
    }

    if (calculatedAge > age) {
      _error = message ?? "Maximum age is $age";
    }

    return this;
  }

  /// Fails when the date comparison with [otherValue] does not satisfy [type].
  DateValidationSupport compareDate(
    String otherValue, {
    required String type, // "less", "greater", "equal"
    String? message,
  }) {
    if (_error != null) return this;

    final date1 = _parseDate();
    final date2 = DateTime.tryParse(otherValue);

    if (date1 == null || date2 == null) {
      _error = message ?? "Invalid date comparison";
      return this;
    }

    bool isValid = false;

    switch (type) {
      case "less":
        isValid = date1.isBefore(date2);
        break;
      case "greater":
        isValid = date1.isAfter(date2);
        break;
      case "equal":
        isValid = date1.isAtSameMomentAs(date2);
        break;
    }

    if (!isValid) {
      _error = message ?? "Date comparison failed";
    }

    return this;
  }

  /// Fails when the date falls on Saturday or Sunday.
  DateValidationSupport disableWeekends({String? message}) {
    if (_error != null) return this;

    final date = _parseDate();

    if (date == null ||
        date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday) {
      _error = message ?? "Weekends not allowed";
    }

    return this;
  }

  /// Applies a custom [validate] function and stores [message] when it fails.
  DateValidationSupport custom(
    bool Function(String value) validate, {
    String? message,
  }) {
    if (_error != null) return this;

    if (!validate(_value)) {
      _error = message ?? "Invalid value";
    }

    return this;
  }

  /// Returns the first validation error, or `null` if all rules passed.
  String? validate() {
    return _error;
  }
}
