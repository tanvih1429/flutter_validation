import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_validator_pro/flutter_validator_pro.dart';

void main() {
  group('DateValidationSupport Tests', () {
    // Required Test
    test('Required - Empty Value', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "")
          .required()
          .validate();

      expect(result, "Field is required");
    });

    test('Required - Valid Value', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2024-01-01")
          .required()
          .validate();

      expect(result, null);
    });

    // Date Format
    test('Date Format - Valid Format', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2024-01-01")
          .dateFormat("yyyy-MM-dd")
          .validate();

      expect(result, null);
    });

    test('Date Format - Invalid Format', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "01/01/2024")
          .dateFormat("yyyy-MM-dd")
          .validate();

      expect(result, "Invalid date format");
    });

    test('Date Format - Multiple Formats', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "01/01/2024")
          .dateFormat(["yyyy-MM-dd", "dd/MM/yyyy"])
          .validate();

      expect(result, null);
    });

    // Past Date
    test('Past Date - Valid', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2020-01-01")
          .pastDate()
          .validate();

      expect(result, null);
    });

    test('Past Date - Future Date', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2099-01-01")
          .pastDate()
          .validate();

      expect(result, "Date must be in the past");
    });

    // Future Date
    test('Future Date - Valid', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2099-01-01")
          .futureDate()
          .validate();

      expect(result, null);
    });

    test('Future Date - Past Date', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2020-01-01")
          .futureDate()
          .validate();

      expect(result, "Date must be in the future");
    });

    // Date Range
    test('Date Range - Valid', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2024-01-01")
          .dateRange(min: DateTime(2023, 1, 1), max: DateTime(2025, 1, 1))
          .validate();

      expect(result, null);
    });

    test('Date Range - Out of Range', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2022-01-01")
          .dateRange(min: DateTime(2023, 1, 1), max: DateTime(2025, 1, 1))
          .validate();

      expect(result, "Date out of range");
    });

    // Min Age
    test('Min Age - Valid', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2000-01-01")
          .minAge(18)
          .validate();

      expect(result, null);
    });

    test('Min Age - Invalid', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2015-01-01")
          .minAge(18)
          .validate();

      expect(result, "Minimum age is 18");
    });

    // Max Age
    test('Max Age - Valid', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2000-01-01")
          .maxAge(50)
          .validate();

      expect(result, null);
    });

    test('Max Age - Invalid', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "1950-01-01")
          .maxAge(50)
          .validate();

      expect(result, "Maximum age is 50");
    });

    // Compare Date
    test('Compare Date - Less', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2020-01-01")
          .compareDate("2021-01-01", type: "less")
          .validate();

      expect(result, null);
    });

    test('Compare Date - Greater Fail', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2020-01-01")
          .compareDate("2021-01-01", type: "greater")
          .validate();

      expect(result, "Date comparison failed");
    });

    // Disable Weekends
    test('Disable Weekends - Weekday', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2024-04-01")
          .disableWeekends()
          .validate();

      expect(result, null);
    });

    test('Disable Weekends - Weekend', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2024-04-07")
          .disableWeekends()
          .validate();

      expect(result, "Weekends not allowed");
    });

    // Custom Validator
    test('Custom - Valid', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2024-01-01")
          .custom((value) => value.startsWith("2024"))
          .validate();

      expect(result, null);
    });

    test('Custom - Invalid', () {
      final result = FlutterValidatorPro()
          .dateValidationSupport(value: "2023-01-01")
          .custom((value) => value.startsWith("2024"))
          .validate();

      expect(result, "Invalid value");
    });
  });
}
