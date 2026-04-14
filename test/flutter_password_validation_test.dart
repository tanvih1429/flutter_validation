import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_validator_pro/src/validation_support/password_validation_support.dart';

void main() {
  test('returns null for a valid password', () {
    var validation = PasswordValidationSupport('Bharat@123')
        .isRequired()
        .minLength(8)
        .maxLength(15)
        .hasUppercase()
        .hasLowercase()
        .hasNumber()
        .hasSpecialCharacter()
        .noSpaces()
        .validate();

    expect(validation, isNull);
  });

  test('fails when password is empty', () {
    var validation = PasswordValidationSupport('').isRequired().validate();

    expect(validation, 'Password is required');
  });

  test('fails when password is shorter than minimum length', () {
    var validation = PasswordValidationSupport('Bh@12').minLength(8).validate();

    expect(validation, 'Password must be at least 8 characters');
  });

  test('fails when password is greater than maximum length', () {
    var validation = PasswordValidationSupport(
      'BharatPassword@123',
    ).maxLength(15).validate();

    expect(validation, 'Password must be less than 15 characters');
  });

  test('fails when password has no uppercase letter', () {
    var validation = PasswordValidationSupport(
      'bharat@123',
    ).hasUppercase().validate();

    expect(validation, 'Password must contain at least one uppercase letter');
  });

  test('fails when password has no lowercase letter', () {
    var validation = PasswordValidationSupport(
      'BHARAT@123',
    ).hasLowercase().validate();

    expect(validation, 'Password must contain at least one lowercase letter');
  });

  test('fails when password has no number', () {
    var validation = PasswordValidationSupport(
      'Bharat@',
    ).hasNumber().validate();

    expect(validation, 'Password must contain at least one number');
  });

  test('fails when password has no special character', () {
    var validation = PasswordValidationSupport(
      'Bharat123',
    ).hasSpecialCharacter().validate();

    expect(validation, 'Password must contain at least one special character');
  });

  test('fails when password contains spaces', () {
    var validation = PasswordValidationSupport(
      'Bharat @123',
    ).noSpaces().validate();

    expect(validation, 'Password should not contain spaces');
  });

  test('returns first error when multiple validations fail', () {
    var validation = PasswordValidationSupport(
      '',
    ).isRequired().minLength(8).hasUppercase().validate();

    expect(validation, 'Password is required');
  });

  test('uses custom message for isRequired', () {
    var validation = PasswordValidationSupport(
      '',
    ).isRequired(message: 'Please enter password').validate();

    expect(validation, 'Please enter password');
  });

  test('uses custom message for minLength', () {
    var validation = PasswordValidationSupport(
      'Bh@1',
    ).minLength(8, message: 'Minimum 8 chars required').validate();

    expect(validation, 'Minimum 8 chars required');
  });

  test('uses custom message for maxLength', () {
    var validation = PasswordValidationSupport(
      'BharatPassword@123',
    ).maxLength(15, message: 'Password is too long').validate();

    expect(validation, 'Password is too long');
  });

  test('uses custom message for uppercase validation', () {
    var validation = PasswordValidationSupport(
      'bharat@123',
    ).hasUppercase(message: 'Add one capital letter').validate();

    expect(validation, 'Add one capital letter');
  });

  test('uses custom message for lowercase validation', () {
    var validation = PasswordValidationSupport(
      'BHARAT@123',
    ).hasLowercase(message: 'Add one small letter').validate();

    expect(validation, 'Add one small letter');
  });

  test('uses custom message for number validation', () {
    var validation = PasswordValidationSupport(
      'Bharat@',
    ).hasNumber(message: 'Add one digit').validate();

    expect(validation, 'Add one digit');
  });

  test('uses custom message for special character validation', () {
    var validation = PasswordValidationSupport(
      'Bharat123',
    ).hasSpecialCharacter(message: 'Add one special symbol').validate();

    expect(validation, 'Add one special symbol');
  });

  test('uses custom message for noSpaces validation', () {
    var validation = PasswordValidationSupport(
      'Bharat @123',
    ).noSpaces(message: 'Spaces are not allowed').validate();

    expect(validation, 'Spaces are not allowed');
  });
}
