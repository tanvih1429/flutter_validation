import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_validator_pro/src/validation_support/name_validation_support.dart';

void main() {
  test('returns null for a valid name', () {
    var validation = NameValidationSupport('Bharat Chaudhari')
        .isRequired()
        .minLength(3)
        .maxLength(30)
        .noNumbers()
        .noSpecialCharacters()
        .noExtraSpaces()
        .startsWithLetter()
        .isFullName()
        .validate();

    expect(validation, isNull);
  });

  test('fails when name is empty', () {
    var validation = NameValidationSupport('').isRequired().validate();

    expect(validation, 'Name is required');
  });

  test('fails when name is too short', () {
    var validation = NameValidationSupport('Bh').minLength(3).validate();

    expect(validation, 'Name must be at least 3 characters');
  });

  test('fails when name is too long', () {
    var validation = NameValidationSupport(
      'Bharat Chaudhari Kothari Developer',
    ).maxLength(20).validate();

    expect(validation, 'Name must be less than 20 characters');
  });

  test('fails when name contains numbers', () {
    var validation = NameValidationSupport('Bharat123').noNumbers().validate();

    expect(validation, 'Name should not contain numbers');
  });

  test('fails when name contains special characters', () {
    var validation = NameValidationSupport(
      'Bharat@Chaudhari',
    ).noSpecialCharacters().validate();

    expect(validation, 'Name should not contain special characters');
  });

  test('fails when name contains multiple spaces', () {
    var validation = NameValidationSupport(
      'Bharat  Chaudhari',
    ).noExtraSpaces().validate();

    expect(validation, 'Name should not contain multiple spaces');
  });

  test('fails when name does not start with a letter', () {
    var validation = NameValidationSupport(
      '1Bharat',
    ).startsWithLetter().validate();

    expect(validation, 'Name must start with a letter');
  });

  test('fails when full name is required but only one word is given', () {
    var validation = NameValidationSupport('Bharat').isFullName().validate();

    expect(validation, 'Please enter full name');
  });

  test('supports custom validator success', () {
    var validation = NameValidationSupport('Bharat Chaudhari')
        .custom(
          (value) => value.startsWith('B'),
          message: 'Name must start with B',
        )
        .validate();

    expect(validation, isNull);
  });

  test('supports custom validator failure', () {
    var validation = NameValidationSupport('harat Chaudhari')
        .custom(
          (value) => value.startsWith('B'),
          message: 'Name must start with B',
        )
        .validate();

    expect(validation, 'Name must start with B');
  });

  test('uses custom message for required validation', () {
    var validation = NameValidationSupport(
      '',
    ).isRequired(message: 'Please enter your name').validate();

    expect(validation, 'Please enter your name');
  });

  test('uses custom message for number validation', () {
    var validation = NameValidationSupport(
      'Bharat123',
    ).noNumbers(message: 'Digits are not allowed in name').validate();

    expect(validation, 'Digits are not allowed in name');
  });
}
