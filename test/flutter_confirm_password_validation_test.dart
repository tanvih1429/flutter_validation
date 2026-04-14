import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_validator_pro/src/validation_support/confirm_password_validation_support.dart';

void main() {
  group('ConfirmPasswordValidationSupport', () {
    test('returns null when confirm password matches password', () {
      final validation = ConfirmPasswordValidationSupport(
        password: 'Bharat@123',
        confirmPassword: 'Bharat@123',
      ).isRequired().matchesPassword().validate();

      expect(validation, isNull);
    });

    test('fails when confirm password is empty', () {
      final validation = ConfirmPasswordValidationSupport(
        password: 'Bharat@123',
        confirmPassword: '',
      ).isRequired().validate();

      expect(validation, 'Confirm password is required');
    });

    test('fails when password and confirm password do not match', () {
      final validation = ConfirmPasswordValidationSupport(
        password: 'Bharat@123',
        confirmPassword: 'Bharat@124',
      ).matchesPassword().validate();

      expect(validation, 'Passwords do not match');
    });

    test(
      'returns first error when confirm password is empty and match check is also called',
      () {
        final validation = ConfirmPasswordValidationSupport(
          password: 'Bharat@123',
          confirmPassword: '',
        ).isRequired().matchesPassword().validate();

        expect(validation, 'Confirm password is required');
      },
    );

    test('uses custom message for isRequired', () {
      final validation = ConfirmPasswordValidationSupport(
        password: 'Bharat@123',
        confirmPassword: '',
      ).isRequired(message: 'Please confirm your password').validate();

      expect(validation, 'Please confirm your password');
    });

    test('uses custom message for matchesPassword', () {
      final validation = ConfirmPasswordValidationSupport(
        password: 'Bharat@123',
        confirmPassword: 'Wrong@123',
      ).matchesPassword(message: 'Both passwords must be same').validate();

      expect(validation, 'Both passwords must be same');
    });

    test('supports custom validator success', () {
      final validation =
          ConfirmPasswordValidationSupport(
                password: 'Bharat@123',
                confirmPassword: 'Bharat@123',
              )
              .custom(
                (password, confirmPassword) => confirmPassword.startsWith('B'),
                message: 'Confirm password must start with B',
              )
              .validate();

      expect(validation, isNull);
    });

    test('supports custom validator failure', () {
      final validation =
          ConfirmPasswordValidationSupport(
                password: 'Bharat@123',
                confirmPassword: 'bharat@123',
              )
              .custom(
                (password, confirmPassword) => confirmPassword.startsWith('B'),
                message: 'Confirm password must start with B',
              )
              .validate();

      expect(validation, 'Confirm password must start with B');
    });

    test('supports custom validator comparing both values', () {
      final validation =
          ConfirmPasswordValidationSupport(
                password: 'Bharat@123',
                confirmPassword: 'Bharat@123',
              )
              .custom(
                (password, confirmPassword) =>
                    password == confirmPassword && confirmPassword.length >= 8,
                message: 'Confirm password is invalid',
              )
              .validate();

      expect(validation, isNull);
    });

    test(
      'custom validator returns error when both values comparison fails',
      () {
        final validation =
            ConfirmPasswordValidationSupport(
                  password: 'Bharat@123',
                  confirmPassword: 'short',
                )
                .custom(
                  (password, confirmPassword) =>
                      password == confirmPassword &&
                      confirmPassword.length >= 8,
                  message: 'Confirm password is invalid',
                )
                .validate();

        expect(validation, 'Confirm password is invalid');
      },
    );
  });
}
