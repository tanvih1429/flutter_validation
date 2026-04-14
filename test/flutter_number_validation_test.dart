import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_validator_pro/src/validation_support/number_validation_support.dart';

void main() {
  test('returns null for valid OTP', () {
    var validation = NumberValidationSupport(
      '123456',
    ).isRequired().digitsOnly().exactLength(6).noSpaces().validate();

    expect(validation, isNull);
  });

  test('fails when number is empty', () {
    var validation = NumberValidationSupport('').isRequired().validate();

    expect(validation, 'Number is required');
  });

  test('fails when non-digit characters are used', () {
    var validation = NumberValidationSupport('12a45').digitsOnly().validate();

    expect(validation, 'Only digits are allowed');
  });

  test('fails when exact length does not match', () {
    var validation = NumberValidationSupport('1234').exactLength(6).validate();

    expect(validation, 'Must be exactly 6 digits');
  });

  test('fails when minimum length is not met', () {
    var validation = NumberValidationSupport('12').minLength(4).validate();

    expect(validation, 'Must be at least 4 digits');
  });

  test('fails when maximum length is exceeded', () {
    var validation = NumberValidationSupport('1234567').maxLength(6).validate();

    expect(validation, 'Must be less than 6 digits');
  });

  test('returns null for valid age', () {
    var validation = NumberValidationSupport(
      '25',
    ).isRequired().digitsOnly().isInteger().inRange(1, 120).validate();

    expect(validation, isNull);
  });

  test('fails when age is below range', () {
    var validation = NumberValidationSupport('0').inRange(1, 120).validate();

    expect(validation, 'Value must be between 1 and 120');
  });

  test('fails when age is above range', () {
    var validation = NumberValidationSupport('150').inRange(1, 120).validate();

    expect(validation, 'Value must be between 1 and 120');
  });

  test('fails when value is not positive', () {
    var validation = NumberValidationSupport('-1').isPositive().validate();

    expect(validation, 'Value must be greater than 0');
  });

  test('fails when spaces are present', () {
    var validation = NumberValidationSupport('12 34').noSpaces().validate();

    expect(validation, 'Spaces are not allowed');
  });

  test('supports custom validator success', () {
    var validation = NumberValidationSupport('2468')
        .custom(
          (value) => int.parse(value) % 2 == 0,
          message: 'Number must be even',
        )
        .validate();

    expect(validation, isNull);
  });

  test('supports custom validator failure', () {
    var validation = NumberValidationSupport('1357')
        .custom(
          (value) => int.parse(value) % 2 == 0,
          message: 'Number must be even',
        )
        .validate();

    expect(validation, 'Number must be even');
  });

  test('uses custom message for digitsOnly', () {
    var validation = NumberValidationSupport(
      '12a',
    ).digitsOnly(message: 'Please enter digits only').validate();

    expect(validation, 'Please enter digits only');
  });

  test('uses custom message for range validation', () {
    var validation = NumberValidationSupport(
      '130',
    ).inRange(1, 120, message: 'Age must be between 1 and 120').validate();

    expect(validation, 'Age must be between 1 and 120');
  });
}
