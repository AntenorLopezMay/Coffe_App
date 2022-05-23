import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool _isLoading = false;
  bool isLoginForm = true;
  bool isPasswordVisible = false;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // String get email => _email;
  // String get password => _password;
  // bool get isLoginForm => _isLoginForm;
  // bool get isPasswordVisible => _isPasswordVisible;

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // void setEmail(String email) {
  //   _email = email;
  //   notifyListeners();
  // }

  // void setPassword(String password) {
  //   _password = password;
  //   notifyListeners();
  // }

  // void setIsLoading(bool isLoading) {
  //   _isLoading = isLoading;
  //   notifyListeners();
  // }

  // void setIsLoginForm(bool isLoginForm) {
  //   _isLoginForm = isLoginForm;
  //   notifyListeners();
  // }

  // void setIsPasswordVisible(bool isPasswordVisible) {
  //   _isPasswordVisible = isPasswordVisible;
  //   notifyListeners();
  // }
}
