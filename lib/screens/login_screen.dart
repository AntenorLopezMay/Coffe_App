import 'package:coffee_app/providers/login_from_provider.dart';
import 'package:coffee_app/services/auth_services.dart';
import 'package:flutter/material.dart';

import 'package:coffee_app/widgets/widgets.dart';
import 'package:coffee_app/ui/input_decorations.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 250),
            CardContainer(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text('Login', style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 30),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: const _LoginForm(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'register'),
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder())),
              child: const Text(
                'Crear una nueva cuenta',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
        child: Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        TextFormField(
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecorations.authInputDecoration(
            hintText: 'antenor.doe@gmail.com',
            labelText: 'Correo electr??nico',
            prefixIcon: Icons.alternate_email_outlined,
          ),
          onChanged: (value) => loginForm.email = value,
          validator: (value) {
            String pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regExp = RegExp(pattern);
            return regExp.hasMatch(value ?? '')
                ? null
                : 'El correo electr??nico no es v??lido';
          },
        ),
        const SizedBox(height: 30),
        TextFormField(
          autocorrect: false,
          obscureText: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecorations.authInputDecoration(
            hintText: '********',
            labelText: 'Correo electr??nico',
            prefixIcon: Icons.lock_outline,
          ),
          onChanged: (value) => loginForm.password = value,
          validator: (value) {
            if (value != null && value.length >= 6) return null;
            return 'La contrase??a debe tener al menos 6 caracteres';
          },
        ),
        const SizedBox(height: 30),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          disabledColor: Colors.grey,
          elevation: 0,
          color: Colors.deepPurple,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: Text(loginForm.isLoading ? 'Cargando...' : 'Iniciar sesi??n',
                style: const TextStyle(color: Colors.white)),
          ),
          onPressed: loginForm.isLoading
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  if (!loginForm.isValidForm()) return;

                  // TODO: Validar si el login es correcto
                  loginForm.isLoading = true;

                  FocusScope.of(context).unfocus();

                  final authService = Provider.of<AuthService>(
                    context,
                    listen: false,
                  );
                  if (!loginForm.isValidForm()) return;

                  loginForm.isLoading = true;
                  final String? resp = await authService.login(
                    loginForm.email,
                    loginForm.password,
                  );

                  if (resp == null) {
                    Navigator.pushReplacementNamed(context, 'home');
                  } else {
                    // TODO: Mostrar error en pantalla
                    print(resp);
                    loginForm.isLoading = false;
                  }
                },
        )
      ]),
    ));
  }
}
