# flutter_validator_pro

`flutter_validator_pro` is a lightweight Flutter package for chainable form validation.

It helps you keep validation logic outside widgets while still returning the standard `String?` result used by `TextFormField.validator`.

## Features

- Chain multiple validation rules in a readable way
- Supports email, password, confirm password, contact number, name, number, date, time, and URL validation
- Returns the first error message found
- Returns `null` when validation passes
- Includes `multiValidator(...)` support for combining multiple field validations

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_validator_pro: ^0.1.3
```

Then run:

```bash
flutter pub get
```

## Import

```dart
import 'package:flutter_validator_pro/flutter_validator_pro.dart';
```

## Quick Start

```dart
final error = FlutterValidatorPro()
    .emailValidator(value: 'john@example.com')
    .isRequired()
    .isValidEmail()
    .noSpaces()
    .validate();
```

With a `TextFormField`:

```dart
TextFormField(
  validator: (value) => FlutterValidatorPro()
      .emailValidator(value: value)
      .isRequired()
      .isValidEmail()
      .singleAtSymbol()
      .noConsecutiveDots()
      .validate(),
)
```

## Available Validators

The main entry point is:

```dart
final validator = FlutterValidatorPro();
```

From there you can start a validation chain using:

- `emailValidator(value: ...)`
- `passwordValidator(value: ...)`
- `confirmPasswordValidator(password: ..., confirmPassword: ...)`
- `contactValidator(value: ...)`
- `nameValidator(value: ...)`
- `numberValidator(value: ...)`
- `dateValidationSupport(value: ...)`
- `timeValidationSupport(value: ...)`
- `urlValidationSupport(value: ...)`
- `multiValidator(validations: [...])`

## Examples

### Email validation

```dart
final error = FlutterValidatorPro()
    .emailValidator(value: 'user@gmail.com')
    .isRequired()
    .isValidEmail()
    .noSpaces()
    .singleAtSymbol()
    .noConsecutiveDots()
    .validate();
```

### Password validation

```dart
final error = FlutterValidatorPro()
    .passwordValidator(value: 'MyPass@123')
    .isRequired()
    .minLength(8)
    .hasUppercase()
    .hasLowercase()
    .hasNumber()
    .hasSpecialCharacter()
    .noSpaces()
    .validate();
```

### Confirm password validation

```dart
final error = FlutterValidatorPro()
    .confirmPasswordValidator(
      password: 'MyPass@123',
      confirmPassword: 'MyPass@123',
    )
    .isRequired()
    .matchesPassword()
    .validate();
```

### Contact number validation

```dart
final error = FlutterValidatorPro()
    .contactValidator(value: '+919876543210')
    .isRequired()
    .isNumeric()
    .isIndianNumber()
    .validate();
```

### Name validation

```dart
final error = FlutterValidatorPro()
    .nameValidator(value: 'John Doe')
    .isRequired()
    .minLength(3)
    .noNumbers()
    .isFullName()
    .validate();
```

### Number validation

```dart
final error = FlutterValidatorPro()
    .numberValidator(value: '25')
    .isRequired()
    .digitsOnly()
    .minValue(18)
    .maxValue(60)
    .validate();
```

### Date validation

```dart
final error = FlutterValidatorPro()
    .dateValidationSupport(value: '2000-05-20')
    .required()
    .minAge(18)
    .validate();
```

### Time validation

```dart
final error = FlutterValidatorPro()
    .timeValidationSupport(value: '14:30')
    .required()
    .timeFormat('HH:mm')
    .timeRange(start: '09:00', end: '18:00')
    .validate();
```

### URL validation

```dart
final error = FlutterValidatorPro()
    .urlValidationSupport(value: 'https://example.com/profile')
    .required()
    .validUrl()
    .httpsOnly()
    .validDomain()
    .validate();
```

### Combine multiple validators

```dart
final emailError = FlutterValidatorPro()
    .emailValidator(value: 'john@example.com')
    .isRequired()
    .isValidEmail()
    .validate();

final passwordError = FlutterValidatorPro()
    .passwordValidator(value: 'pass')
    .minLength(8)
    .validate();

final error = FlutterValidatorPro().multiValidator(
  validations: [emailError, passwordError],
);
```

## How It Works

Each rule checks the current value and stores the first validation error.
If a rule fails, later rules do not replace that message.

`validate()` returns:

- `null` when all applied rules pass
- A `String` error message when validation fails

## Pub.dev Notes

- Use `FlutterValidatorPro` as the main class name.
- Import the package with `flutter_validator_pro.dart`.
- Custom messages are supported by most validation methods through the `message` parameter.

## Running Tests

```bash
flutter test
```
