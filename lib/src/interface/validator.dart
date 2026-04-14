import 'package:flutter_validator_pro/src/validation_support/confirm_password_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/contact_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/date_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/email_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/name_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/number_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/password_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/time_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/url_validation_support.dart';

/// Contract for the validator factory exposed by this package.
abstract class Validator {
  /// Starts an email validation chain for [value].
  EmailValidationSupport? emailValidator({required String? value});

  /// Starts a contact number validation chain for [value].
  ContactValidationSupport? contactValidator({required String? value});

  /// Starts a password validation chain for [value].
  PasswordValidationSupport passwordValidator({required String? value});

  /// Starts a confirm-password validation chain.
  ConfirmPasswordValidationSupport confirmPasswordValidator({
    required String? password,
    required String? confirmPassword,
  });

  /// Starts a name validation chain for [value].
  NameValidationSupport nameValidator({required String? value});

  /// Starts a number validation chain for [value].
  NumberValidationSupport numberValidator({required String? value});

  /// Returns the first non-null value from [validations].
  String? multiValidator({required List<String?> validations});

  /// Starts a date validation chain for [value].
  DateValidationSupport dateValidationSupport({required String? value});

  /// Starts a time validation chain for [value].
  TimeValidationSupport timeValidationSupport({required String? value});

  /// Starts a URL validation chain for [value].
  UrlValidationSupport urlValidationSupport({required String? value});
}
