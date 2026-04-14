import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_validator_pro/src/validation_support/contact_validation_support.dart';

void main() {
  test('returns null for a valid contact number', () {
    var validation = ContactValidationSupport('+919876543210')
        .isRequired()
        .isNumeric()
        .isE164Format()
        .isIndianNumber()
        .minLength(10)
        .maxLength(15)
        .validate();

    expect(validation, isNull);
  });

  test('fails when contact number is empty', () {
    var validation = ContactValidationSupport('').isRequired().validate();

    expect(validation, 'Contact number is required');
  });

  test('fails when contact number contains invalid characters', () {
    var validation = ContactValidationSupport(
      '98765abc',
    ).isNumeric().validate();

    expect(validation, 'Contact number must contain only valid digits');
  });

  test(
    'fails when contact number without plus contains plus (allowPlus false)',
    () {
      var validation = ContactValidationSupport(
        '+1234567890',
      ).isNumeric(allowPlus: false).validate();

      expect(validation, 'Contact number must contain only valid digits');
    },
  );

  test('fails when contact number is not in E.164 format', () {
    var validation = ContactValidationSupport(
      '14155552671',
    ).isE164Format().validate();

    expect(validation, 'Number must be in E.164 format (e.g., +1234567890)');
  });

  test('fails when contact number has invalid general format', () {
    var validation = ContactValidationSupport(
      'random text',
    ).isValidGeneralFormat().validate();

    expect(validation, 'Invalid contact number format');
  });

  test('fails when Indian contact number is invalid', () {
    var validation = ContactValidationSupport(
      '5876543210',
    ).isIndianNumber().validate();

    expect(validation, 'Invalid Indian contact number');
  });

  test('fails when US/Canada contact number is invalid', () {
    var validation = ContactValidationSupport(
      '155-555-1234',
    ).isUSNumber().validate();

    expect(validation, 'Invalid US/Canada contact number');
  });

  test('fails when contact number is shorter than minimum length', () {
    // Has 7 digits
    var validation = ContactValidationSupport(
      '+1 (234) 567',
    ).minLength(10).validate();

    expect(validation, 'Contact number must have at least 10 digits');
  });

  test('fails when contact number is greater than maximum length', () {
    // Has 13 digits
    var validation = ContactValidationSupport(
      '+91987654321012',
    ).maxLength(10).validate();

    expect(validation, 'Contact number must not exceed 10 digits');
  });

  test('returns first error when multiple validations fail', () {
    var validation = ContactValidationSupport(
      '',
    ).isRequired().minLength(10).isNumeric().validate();

    expect(validation, 'Contact number is required');
  });

  test('uses custom validation logic successfully', () {
    var validation = ContactValidationSupport(
      '991234',
    ).custom((val) => val.startsWith('99'), 'Must start with 99').validate();

    expect(validation, isNull);
  });

  test('fails using custom validation logic', () {
    var validation = ContactValidationSupport(
      '881234',
    ).custom((val) => val.startsWith('99'), 'Must start with 99').validate();

    expect(validation, 'Must start with 99');
  });

  test('uses custom message for isRequired', () {
    var validation = ContactValidationSupport(
      '',
    ).isRequired(message: 'Please enter a contact number').validate();

    expect(validation, 'Please enter a contact number');
  });

  test('uses custom message for isNumeric', () {
    var validation = ContactValidationSupport(
      '123abc456',
    ).isNumeric(message: 'Only numbers are allowed').validate();

    expect(validation, 'Only numbers are allowed');
  });

  test('uses custom message for isE164Format', () {
    var validation = ContactValidationSupport(
      '12345',
    ).isE164Format(message: 'Use international format with +').validate();

    expect(validation, 'Use international format with +');
  });

  test('uses custom message for isValidGeneralFormat', () {
    var validation = ContactValidationSupport(
      'abc',
    ).isValidGeneralFormat(message: 'Enter a proper phone number').validate();

    expect(validation, 'Enter a proper phone number');
  });

  test('uses custom message for isIndianNumber', () {
    var validation = ContactValidationSupport(
      '1234567890',
    ).isIndianNumber(message: 'Enter a valid Indian mobile number').validate();

    expect(validation, 'Enter a valid Indian mobile number');
  });

  test('uses custom message for isUSNumber', () {
    var validation = ContactValidationSupport(
      '12345',
    ).isUSNumber(message: 'Enter a valid US mobile number').validate();

    expect(validation, 'Enter a valid US mobile number');
  });

  test('uses custom message for minLength', () {
    var validation = ContactValidationSupport(
      '123',
    ).minLength(10, message: 'Number is too short').validate();

    expect(validation, 'Number is too short');
  });

  test('uses custom message for maxLength', () {
    var validation = ContactValidationSupport(
      '1234567890123456',
    ).maxLength(15, message: 'Number is too long').validate();

    expect(validation, 'Number is too long');
  });
}
