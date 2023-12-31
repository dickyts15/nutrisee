import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/user_model.dart';
import 'package:nutrisee/pages/home_page.dart';
import 'package:nutrisee/pages/welcome_page.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/firebase_auth.dart';
import 'package:nutrisee/pages/login_page.dart';
import 'package:nutrisee/utils/restapi.dart';
import 'package:nutrisee/utils/validator.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _gender = 'Laki-laki';

  final _focusName = FocusNode();
  final _focusUsername = FocusNode();
  final _focusTanggalLahir = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusHeight = FocusNode();
  final _focusWeight = FocusNode();

  bool _isProcessing = false;
  bool _obscureText = true;

  DataService ds = DataService();

  late Future<DateTime?> selectedDate;
  String date = '-';
  int _age = 0;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              HomePage(user: user, loggedEmail: user.email.toString()),
        ),
      );
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusUsername.unfocus();
        _focusTanggalLahir.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
        _focusHeight.unfocus();
        _focusWeight.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'nutrisee.jpg',
                    height: 200,
                    width: 200,
                  ),
                  Text(
                    'Register',
                    style: GoogleFonts.crimsonPro(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 0, 120, 74)),
                  ),
                  Text(
                    'Registrasi Akun Nutrisee Anda',
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameTextController,
                          focusNode: _focusName,
                          validator: (value) => Validator.validateName(
                            name: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Nama Lengkap",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: _usernameTextController,
                          focusNode: _focusUsername,
                          validator: (value) => Validator.validateUsername(
                            username: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Username",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _tanggalLahirController,
                          focusNode: _focusTanggalLahir,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Date can't be empty";
                            }
                            return null;
                          },
                          onTap: () {
                            showDialogPicker(context);
                          },
                          decoration: InputDecoration(
                            hintText: "Tanggal Lahir",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) => Validator.validateEmail(
                            email: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Email",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: _obscureText,
                          validator: (value) => Validator.validatePassword(
                            password: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _heightController,
                          focusNode: _focusHeight,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              Validator.validateNumber(number: value),
                          decoration: InputDecoration(
                            hintText: "Height",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        TextFormField(
                          controller: _weightController,
                          focusNode: _focusWeight,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              Validator.validateNumber(number: value),
                          decoration: InputDecoration(
                            hintText: "Weight",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _gender = 'Laki-laki';
                                });
                              },
                              child: Text(
                                'Laki-laki',
                                style: GoogleFonts.crimsonPro(
                                  color: Color.fromARGB(255, 21, 21, 21),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary:
                                    _gender == 'Laki-laki' ? Colors.blue : null,
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _gender = 'Perempuan';
                                });
                              },
                              child: Text(
                                'Perempuan',
                                style: GoogleFonts.crimsonPro(
                                  color: Color.fromARGB(255, 21, 21, 21),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary:
                                    _gender == 'Perempuan' ? Colors.pink : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        _isProcessing
                            ? const CircularProgressIndicator()
                            : Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        _focusName.unfocus();
                                        _focusUsername.unfocus();
                                        _focusTanggalLahir.unfocus();
                                        _focusEmail.unfocus();
                                        _focusPassword.unfocus();
                                        _focusHeight.unfocus();
                                        _focusWeight.unfocus();

                                        if (_registerFormKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            _isProcessing = true;
                                          });

                                          User? user = await FireAuth
                                              .registerUsingEmailPassword(
                                            name: _nameTextController.text,
                                            email: _emailTextController.text,
                                            password:
                                                _passwordTextController.text,
                                          );

                                          List response =
                                              jsonDecode(await ds.insertUser(
                                            appid,
                                            _usernameTextController.text,
                                            _emailTextController.text,
                                            Crypt.sha256(_passwordTextController
                                                    .text)
                                                .toString(),
                                            _gender,
                                            _age.toString(),
                                            _nameTextController.text,
                                            "-",
                                            _weightController.text,
                                            _heightController.text,
                                            caloriesTarget().toStringAsFixed(0),
                                            "-",
                                            "-",
                                            _tanggalLahirController.text,
                                            "Sedentary (office job)",
                                          ));
                                          List<UserModel> users = response
                                              .map((e) => UserModel.fromJson(e))
                                              .toList();

                                          setState(() {
                                            _isProcessing = false;
                                          });

                                          if (user != null &&
                                              users.length == 1) {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const WelcomePage(),
                                              ),
                                              ModalRoute.withName('/'),
                                            );
                                          } else {
                                            if (kDebugMode) {
                                              print(response);
                                            }
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        onPrimary: Colors.white,
                                        side: BorderSide(color: Colors.blue),
                                        minimumSize: Size(237, 58),
                                      ),
                                      child: Text(
                                        'Register',
                                        style: GoogleFonts.crimsonPro(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun?  ',
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Login',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              }),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDialogPicker(BuildContext context) {
    var date = DateTime.now();

    selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime(date.year, date.month, date.day),
      firstDate: DateTime(1980),
      lastDate: DateTime(date.year, date.month, date.day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    selectedDate.then((value) {
      setState(() {
        //Prevent Error When Null Close
        if (value == null) return;

        final DateFormat formatter = DateFormat('d MMMM yyyy');
        final String formattedDate = formatter.format(value);
        _tanggalLahirController.text = formattedDate;
        _age = DateTime.now().year - value.year;
      });
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  double caloriesTarget() {
    double result = 0.0;
    if (_gender == 'Laki-laki') {
      result = (10 * double.parse(_weightController.text)) +
          (6.25 * double.parse(_heightController.text)) -
          (5 * _age) +
          5;
    } else if (_gender == 'Perempuan') {
      result = (10 * double.parse(_weightController.text)) +
          (6.25 * double.parse(_heightController.text)) -
          (5 * _age) -
          161;
    } else {
      result = 0;
    }
    return result;
  }
}
