import 'package:intl/intl.dart';

/// Comparison types used by [TimeValidationSupport.compareTime].
enum TimeCompareType {
  /// Requires the input time to be earlier than the comparison value.
  less,

  /// Requires the input time to be later than the comparison value.
  greater,

  /// Requires the input time to be equal to the comparison value.
  equal,
}

/// Chainable validation rules for time values.
class TimeValidationSupport {
  final String _value;
  String? _error;

  /// Creates a time validator for the provided value.
  TimeValidationSupport(this._value);

  /// Returns the first validation error, or `null` if all rules passed.
  String? validate() => _error;

  /// Internal parser
  DateTime? _parse(String value, String format) {
    try {
      return DateFormat(format).parseStrict(value);
    } catch (_) {
      return null;
    }
  }

  /// Fails when the value is empty or contains only whitespace.
  TimeValidationSupport required({String? message}) {
    if (_error != null) return this;

    if (_value.trim().isEmpty) {
      _error = message ?? "Field is required";
    }
    return this;
  }

  /// Fails when the value does not match the provided time [format].
  TimeValidationSupport timeFormat(String format, {String? message}) {
    if (_error != null) return this;

    if (_parse(_value, format) == null) {
      _error = message ?? "Invalid time format";
    }

    return this;
  }

  /// Fails when the value does not match any of the provided [formats].
  TimeValidationSupport timeFormats(List<String> formats, {String? message}) {
    if (_error != null) return this;

    bool isValid = false;

    for (var format in formats) {
      if (_parse(_value, format) != null) {
        isValid = true;
        break;
      }
    }

    if (!isValid) {
      _error = message ?? "Invalid time format";
    }

    return this;
  }

  /// Fails when the time is outside the inclusive [start] and [end] range.
  TimeValidationSupport timeRange({
    required String start,
    required String end,
    String format = "HH:mm",
    String? message,
  }) {
    if (_error != null) return this;

    final input = _parse(_value, format);
    final startTime = _parse(start, format);
    final endTime = _parse(end, format);

    if (input == null || startTime == null || endTime == null) {
      _error = message ?? "Invalid time";
      return this;
    }

    if (input.isBefore(startTime) || input.isAfter(endTime)) {
      _error = message ?? "Time out of range";
    }

    return this;
  }

  /// Fails when the time is not later than the current time for today.
  TimeValidationSupport futureTime({String format = "HH:mm", String? message}) {
    if (_error != null) return this;

    final input = _parse(_value, format);
    if (input == null) {
      _error = message ?? "Invalid time";
      return this;
    }

    final now = DateTime.now();
    final current = DateTime(0, 0, 0, now.hour, now.minute);
    final given = DateTime(0, 0, 0, input.hour, input.minute);

    if (!given.isAfter(current)) {
      _error = message ?? "Time must be in the future";
    }

    return this;
  }

  /// Fails when the time is not earlier than the current time for today.
  TimeValidationSupport pastTime({String format = "HH:mm", String? message}) {
    if (_error != null) return this;

    final input = _parse(_value, format);
    if (input == null) {
      _error = message ?? "Invalid time";
      return this;
    }

    final now = DateTime.now();
    final current = DateTime(0, 0, 0, now.hour, now.minute);
    final given = DateTime(0, 0, 0, input.hour, input.minute);

    if (!given.isBefore(current)) {
      _error = message ?? "Time must be in the past";
    }

    return this;
  }

  /// Fails when the time is earlier than [min].
  TimeValidationSupport minTime(
    String min, {
    String format = "HH:mm",
    String? message,
  }) {
    if (_error != null) return this;

    final input = _parse(_value, format);
    final minTime = _parse(min, format);

    if (input == null || minTime == null) {
      _error = message ?? "Invalid time";
      return this;
    }

    if (input.isBefore(minTime)) {
      _error = message ?? "Time must be after $min";
    }

    return this;
  }

  /// Fails when the time is later than [max].
  TimeValidationSupport maxTime(
    String max, {
    String format = "HH:mm",
    String? message,
  }) {
    if (_error != null) return this;

    final input = _parse(_value, format);
    final maxTime = _parse(max, format);

    if (input == null || maxTime == null) {
      _error = message ?? "Invalid time";
      return this;
    }

    if (input.isAfter(maxTime)) {
      _error = message ?? "Time must be before $max";
    }

    return this;
  }

  /// Fails when comparison with [other] does not satisfy [type].
  TimeValidationSupport compareTime(
    String other, {
    required TimeCompareType type,
    String format = "HH:mm",
    String? message,
  }) {
    if (_error != null) return this;

    final t1 = _parse(_value, format);
    final t2 = _parse(other, format);

    if (t1 == null || t2 == null) {
      _error = message ?? "Invalid time comparison";
      return this;
    }

    bool valid = false;

    switch (type) {
      case TimeCompareType.less:
        valid = t1.isBefore(t2);
        break;
      case TimeCompareType.greater:
        valid = t1.isAfter(t2);
        break;
      case TimeCompareType.equal:
        valid = t1.hour == t2.hour && t1.minute == t2.minute;
        break;
    }

    if (!valid) {
      _error = message ?? "Time comparison failed";
    }

    return this;
  }

  /// Fails when the time is equal to [other].
  TimeValidationSupport notEqualTime(
    String other, {
    String format = "HH:mm",
    String? message,
  }) {
    if (_error != null) return this;

    final t1 = _parse(_value, format);
    final t2 = _parse(other, format);

    if (t1 == null || t2 == null) {
      _error = message ?? "Invalid time";
      return this;
    }

    if (t1.hour == t2.hour && t1.minute == t2.minute) {
      _error = message ?? "Time must not be equal";
    }

    return this;
  }

  /// Fails when the time is not aligned to the given minute [minutes] interval.
  TimeValidationSupport interval(
    int minutes, {
    String format = "HH:mm",
    String? message,
  }) {
    if (_error != null) return this;

    final input = _parse(_value, format);

    if (input == null) {
      _error = message ?? "Invalid time";
      return this;
    }

    if (input.minute % minutes != 0) {
      _error = message ?? "Time must be in $minutes minute intervals";
    }

    return this;
  }

  /// Fails when the parsed hour is included in [hours].
  TimeValidationSupport disableHours(
    List<int> hours, {
    String format = "HH:mm",
    String? message,
  }) {
    if (_error != null) return this;

    final input = _parse(_value, format);

    if (input == null) {
      _error = message ?? "Invalid time";
      return this;
    }

    if (hours.contains(input.hour)) {
      _error = message ?? "This time is not allowed";
    }

    return this;
  }

  /// Applies a custom [validate] function and stores [message] when it fails.
  TimeValidationSupport custom(
    bool Function(String value) validate, {
    String? message,
  }) {
    if (_error != null) return this;

    if (!validate(_value)) {
      _error = message ?? "Invalid value";
    }

    return this;
  }
}
