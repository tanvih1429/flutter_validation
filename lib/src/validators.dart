import 'package:flutter_validator_pro/src/validation_support/confirm_password_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/contact_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/date_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/email_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/name_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/number_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/password_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/time_validation_support.dart';
import 'package:flutter_validator_pro/src/validation_support/url_validation_support.dart';
import 'interface/validator.dart';

/// Main entry point for creating chainable validators.
///
/// Create an instance of this class and choose the validator type for the
/// value you want to check, such as email, password, contact number, date,
/// time, or URL.
class FlutterValidatorPro implements Validator {
  /// Creates a new validator factory.
  FlutterValidatorPro();

  /// Starts a contact number validation chain for [value].
  ///
  /// Use the returned [ContactValidationSupport] object to apply rules such as
  /// required, numeric-only, Indian number, US number, or custom validation.
  @override
  ContactValidationSupport? contactValidator({required String? value}) {
    return ContactValidationSupport(value!);
  }

  /// Starts an email validation chain for [value].
  ///
  /// Use the returned [EmailValidationSupport] object to add rules like
  /// required, valid email format, no spaces, domain restrictions, and more.
  @override
  EmailValidationSupport emailValidator({required String? value}) {
    return EmailValidationSupport(value!);
  }

  /// Starts a password validation chain for [value].
  ///
  /// Use the returned [PasswordValidationSupport] object to validate password
  /// strength rules such as minimum length, uppercase, lowercase, numbers,
  /// special characters, and spaces.
  @override
  PasswordValidationSupport passwordValidator({required String? value}) {
    return PasswordValidationSupport(value ?? '');
  }

  /// Starts a confirm-password validation chain.
  ///
  /// Pass both the original [password] and the [confirmPassword] value to
  /// validate whether the confirmation field is required and matches.
  @override
  ConfirmPasswordValidationSupport confirmPasswordValidator({
    required String? password,
    required String? confirmPassword,
  }) {
    return ConfirmPasswordValidationSupport(
      password: password ?? '',
      confirmPassword: confirmPassword ?? '',
    );
  }

  /// Starts a name validation chain for [value].
  @override
  NameValidationSupport nameValidator({required String? value}) {
    return NameValidationSupport(value ?? '');
  }

  /// Starts a number validation chain for [value].
  @override
  NumberValidationSupport numberValidator({required String? value}) {
    return NumberValidationSupport(value ?? '');
  }

  /// Returns the first non-null validation message from [validations].
  ///
  /// This is useful when combining multiple field validators into one
  /// `TextFormField.validator` result.
  @override
  String? multiValidator({required List<String?> validations}) {
    for (var val in validations) {
      if (val != null) return val;
    }
    return null;
  }

  /// Starts a date validation chain for [value].
  @override
  DateValidationSupport dateValidationSupport({required String? value}) {
    return DateValidationSupport(value ?? '');
  }

  /// Starts a time validation chain for [value].
  @override
  TimeValidationSupport timeValidationSupport({required String? value}) {
    return TimeValidationSupport(value ?? "");
  }

  /// Starts a URL validation chain for [value].
  @override
  UrlValidationSupport urlValidationSupport({required String? value}) {
    return UrlValidationSupport(value ?? "");
  }
}
