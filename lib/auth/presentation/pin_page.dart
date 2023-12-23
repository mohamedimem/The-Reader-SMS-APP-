import 'package:auto_route/auto_route.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:proxyapp/auth/application/auth_notifier.dart';
import 'package:proxyapp/auth/domain/email_adress.dart';
import 'package:proxyapp/auth/domain/failure/auth_failure.dart';
import 'package:proxyapp/auth/domain/password.dart';
import 'package:proxyapp/auth/shared/providers.dart';
import 'package:validators/validators.dart' as validator;

@RoutePage()
class PinPage extends StatefulWidget {
  const PinPage({super.key});
  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  TextEditingController nom = TextEditingController();

  bool _wrongName = false;

  @override
  void dispose() {
    nom.dispose();

    super.dispose();
  }

  final wrongPingSnack = SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'On Sorry!',
      message: 'Wrong Pin.',

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: ContentType.failure,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: MainWidget(
                    nom: nom,
                    wrongName: _wrongName,
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final firebaseauth =
                        ref.watch(authNotifierProvider.notifier);
                    return TextButton(
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as needed
                            ),
                          ),
                          minimumSize:
                              MaterialStateProperty.all(const Size(320, 50)),
                          elevation: const MaterialStatePropertyAll(4),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xffB6EE65))),
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (nom.text.length > 7) {
                          try {
                            var state =
                                await firebaseauth.signInWithPin(nom.text);
                            print("-----");
                            print(state);
                            print("-----");
                            if (state == AuthState.failure()) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(wrongPingSnack);
                            }
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(wrongPingSnack);
                          setState(
                            () {
                              if (nom.text.isEmpty) {
                                _wrongName = true;
                              }
                            },
                          );
                        }
                      },
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

class MainWidget extends StatelessWidget {
  const MainWidget({
    super.key,
    required this.nom,
    required this.wrongName,
  });
  final TextEditingController nom;

  final bool wrongName;

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
                if (nom.text == '') {
                  return "Please enter a Pin.";
                }
                return null;
              },
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              controller: nom,
              decoration: InputDecoration(
                errorText: wrongName ? "Please provide a Pin" : null,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                prefixIcon: const Icon(Icons.badge, color: Colors.blue),
                hintText: "Pin",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
