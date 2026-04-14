import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_validator_pro/flutter_validator_pro.dart';

void main() {
  test('Email Formate Check', () {
    var validation = FlutterValidatorPro()
        .emailValidator(value: "bharat.sc01@gmail.com")
        .isRequired()
        .isValidEmail()
        .validate();
    expect(validation, null);
  });

  test('Check Space in email', () {
    var validation = FlutterValidatorPro()
        .emailValidator(value: "bharat .sc01@gmail.com")
        .isRequired()
        .isValidEmail()
        .noSpaces()
        .validate();
    expect(validation, "Email should not contain spaces");
  });

  test('Check @ in email', () {
    var validation = FlutterValidatorPro()
        .emailValidator(value: "bharat.sc01.com")
        .hasAtSymbol()
        .validate();
    expect(validation, "Email must contain @");
  });

  test('Check domain in email', () {
    List<String> domains = [".com", ".outlook", ".in"];
    var validation = FlutterValidatorPro()
        .emailValidator(value: "bharat.sc01.com")
        .allowDomain(domains)
        .validate();
    expect(validation, null);
  });

  test("check multi", () {
    List<String?> validationslist = [
      FlutterValidatorPro()
          .emailValidator(value: "bharat@gmail.com")
          .isValidEmail()
          .validate(),
      FlutterValidatorPro()
          .passwordValidator(value: "bharat1")
          .hasNumber()
          .validate(),
    ];

    var validator = FlutterValidatorPro().multiValidator(
      validations: validationslist,
    );

    expect(validator, null);
  });
}
