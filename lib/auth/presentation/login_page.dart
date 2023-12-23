import 'package:auto_route/auto_route.dart';
import 'package:validators/validators.dart' as validator;

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:proxyapp/auth/application/auth_notifier.dart';
import 'package:proxyapp/auth/domain/email_adress.dart';
import 'package:proxyapp/auth/domain/password.dart';
import 'package:proxyapp/auth/shared/providers.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  bool _wrongEmail = false;
  bool _wrongPassword = false;

  final snackBartrue = SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Welcome',
      message: 'Login successfully',

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: ContentType.success,
    ),
  );
  final snackBarfalse = SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'On Snap!',
      message: 'Invalid email and password',

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: ContentType.failure,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        // Wrap with GestureDetector
        onTap: () {
          FocusScope.of(context)
              .requestFocus(FocusNode()); // Close keyboard on tap
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                MainWidgetLogin(
                  email: email,
                  password: password,
                  wrongEmail: _wrongEmail,
                  wrongPassword: _wrongPassword,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextButton(
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.green, fontSize: 14),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    4.0), // Adjust the radius as needed
                              )),
                              minimumSize: MaterialStateProperty.all(
                                  const Size(320, 50)),
                              elevation: const MaterialStatePropertyAll(4),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xffB6EE65))),
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();

                            if (validator.isEmail(email.text.trim()) &&
                                password.text.length > 6) {
                              final firebaseauth =
                                  ref.watch(authNotifierProvider.notifier);
                              try {
                                var state = await firebaseauth
                                    .signInWithEmailAndPassword(
                                        EmailAdress(email.text.trim()),
                                        Password(password.text.trim()));
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBartrue);

                                if (state == AuthState.failure()) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBarfalse);
                                }
                              } catch (e) {
                                print(e);
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBarfalse);
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBarfalse);
                            }
                          }),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainWidgetLogin extends StatelessWidget {
  const MainWidgetLogin({
    super.key,
    required this.email,
    required this.password,
    required this.wrongEmail,
    required this.wrongPassword,
  });

  final TextEditingController email;
  final TextEditingController password;
  final bool wrongEmail;
  final bool wrongPassword;

  final String _emailText = 'Please use a valid email';
  final String _passwordText = 'Please use a strong password';

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            TextFormField(
              validator: (_) {
                if (EmailValidator.validate(email.text)) {
                  return null;
                } else {
                  return "Please enter a valid email.";
                }
              },
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              controller: email,
              decoration: InputDecoration(
                errorText: wrongEmail ? _emailText : null,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.blue),
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
              ),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            TextFormField(
              validator: (_) {
                if (password.text.length > 6) {
                  return null;
                } else {
                  return "Please enter a valid password.";
                }
              },
              obscureText: true,
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              controller: password,
              decoration: InputDecoration(
                errorText: wrongPassword ? _passwordText : null,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                prefixIcon: const Icon(Icons.key, color: Colors.blue),
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
              ),
              autocorrect: false,
            ),
          ],
        ),
      ),
    ));
  }
}
