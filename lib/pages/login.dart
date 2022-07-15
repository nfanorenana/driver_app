import 'package:another_flushbar/flushbar.dart';
import 'package:driver_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/domain/user.dart';
import 'package:driver_app/providers/auth.dart';
import 'package:driver_app/providers/user_provider.dart';
import 'package:driver_app/util/validators.dart';
import 'package:driver_app/util/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();

  String _email, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final emailField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _email = value,
      decoration: buildInputDecoration("Adresse email", Icons.email),
      keyboardType: TextInputType.emailAddress,
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) =>
          value.isEmpty ? "Veuillez entrer le mot de passe" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Mot de passe", Icons.lock),
      keyboardType: TextInputType.text,
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        // LinearProgressIndicator(),
        CircularProgressIndicator(),
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0.0),
          child: const Text("Mot de passe oublié?",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
//            Navigator.pushReplacementNamed(context, '/reset-password');
          },
        ),
      ],
    );

    doLogin() {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
            auth.login(_email, _password);

        successfulMessage.then((response) {
          if (response['status']) {
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).user = user;
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Flushbar(
              title: "Tentative de connexion échouée",
              message: response['message'].toString(),
              duration: Duration(seconds: 2),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Formulaire invalide",
          message: "Vueillez remplir correctement le formulaire",
          duration: Duration(seconds: 2),
        ).show(context);
      }
    }

    return ScreenUtilInit(
      builder: () => Scaffold(
        body: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primary,
                  primary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 36.0.h, horizontal: 24.0.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connexion',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 32.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.0.w),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            emailField,
                            SizedBox(
                              height: 20.0.h,
                            ),
                            passwordField,
                            SizedBox(
                              height: 20.0.h,
                            ),
                            auth.loggedInStatus == Status.Authenticating
                                ? loading
                                : longButtons("Se connecter", doLogin,
                                    color: Colors.black38),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Divider(
                                    height: 40.h,
                                    thickness: 2,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                ),
                              ],
                            ),
                            // forgotLabel
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      designSize: const Size(480, 640),
    );
  }
}
