import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_validator_pro/flutter_validator_pro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Validation Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      log("Form Valid");
      log("Form Valid ✅");

      // You can test your plugin here
      log(nameController.text);
      log(emailController.text);
      log(passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form Submitted Successfully")),
      );
    } else {
      log("Form Invalid");
      log("Form Invalid ❌");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Validation Form"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// NAME
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// EMAIL
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return FlutterValidatorPro()
                      .emailValidator(value: value)
                      .isRequired()
                      .isValidEmail()
                      .validate();
                },
              ),

              const SizedBox(height: 16),

              /// PASSWORD
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => FlutterValidatorPro()
                    .passwordValidator(value: value)
                    .isRequired()
                    .validate(),
              ),

              const SizedBox(height: 16),

              /// CONFIRM PASSWORD
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => FlutterValidatorPro()
                    .confirmPasswordValidator(
                      password: passwordController.text,
                      confirmPassword: value,
                    )
                    .isRequired()
                    .matchesPassword()
                    .validate(),
              ),

              const SizedBox(height: 24),

              /// BUTTON
              ElevatedButton(
                onPressed: submitForm,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
