import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/user_model.dart';
import 'package:nutrisee/pages/login_page.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/restapi.dart';
import 'package:nutrisee/utils/validator.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DataService ds = DataService();
  final _editFormKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _gender = '-';
  String profpic = ' ';
  bool loadData = false;

  final _focusName = FocusNode();
  final _focusUsername = FocusNode();
  final _focusTanggalLahir = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusHeight = FocusNode();
  final _focusWeight = FocusNode();

  bool _isProcessing = false;
  bool _obscureText = true;

  late Future<DateTime?> selectedDate;

  late User _currentUser;
  String date = '-';
  int _age = 0;
  int _weightGoal = 0;
  String uid = '-';
  int caloriesTarget = 0;
  String password = '-';

  List<UserModel> user = [];

  selectIdUser(String uid) async {
    List data = [];
    data = jsonDecode(
        await ds.selectWhere(token, project, 'user', appid, 'uid', uid));
    user = data.map((e) => UserModel.fromJson(e)).toList();

    setState(() {
      user = user;
      _nameTextController.text = user[0].namauser;
      _usernameTextController.text = user[0].username;
      _tanggalLahirController.text = user[0].tanggallahir;
      _emailTextController.text = user[0].email;
      password = user[0].password;
      _weightController.text = user[0].weight;
      _heightController.text = user[0].height;
      _gender = user[0].gender;
      profpic = user[0].profpic;
      _age = int.parse(user[0].age);
      _weightGoal = int.parse(user[0].weightgoal);
      caloriesTarget = int.parse(user[0].caloriestarget);
      uid = user[0].uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;

    if (loadData == false) {
      selectIdUser(args[0]);

      loadData = true;
    }
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
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 120, 74),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        _nameTextController.text.toString(),
                        style: GoogleFonts.rubik(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 51, 51, 51)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _editFormKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _nameTextController,
                                  focusNode: _focusName,
                                  validator: (value) => Validator.validateName(
                                    name: value,
                                  ),
                                  decoration: InputDecoration(
                                    label: Text('Nama Lengkap'),
                                    hintText: "Nama Lengkap",
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextFormField(
                                  controller: _usernameTextController,
                                  focusNode: _focusUsername,
                                  validator: (value) =>
                                      Validator.validateUsername(
                                    username: value,
                                  ),
                                  decoration: InputDecoration(
                                    label: Text('Username'),
                                    hintText: "Username",
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
                                    label: Text('Email'),
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
                                  controller: _tanggalLahirController,
                                  focusNode: _focusTanggalLahir,
                                  onTap: () {
                                    showDialogPicker(
                                        context, _tanggalLahirController.text);
                                  },
                                  decoration: InputDecoration(
                                    label: Text('Tanggal Lahir'),
                                    hintText: "Tanggal Lahir",
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
                                  controller: _weightController,
                                  focusNode: _focusWeight,
                                  decoration: InputDecoration(
                                    label: Text('Berat Badan'),
                                    hintText: "Weight",
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
                                  controller: _heightController,
                                  focusNode: _focusHeight,
                                  decoration: InputDecoration(
                                    label: Text('Tinggi Badan'),
                                    hintText: "Height",
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.0),
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
                                          color:
                                              Color.fromARGB(255, 21, 21, 21),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: _gender == 'Laki-laki'
                                            ? Colors.blue
                                            : null,
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
                                          color:
                                              Color.fromARGB(255, 21, 21, 21),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: _gender == 'Perempuan'
                                            ? Colors.pink
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                _isProcessing
                                    ? const CircularProgressIndicator()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.blue,
                                                onPrimary: Colors.white,
                                                side: BorderSide(
                                                    color: Colors.blue),
                                                minimumSize: Size(237, 58),
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Warning"),
                                                      content: Text(
                                                          "Edit this data?"),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('CANCEL'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(context);
                                                          },
                                                        ),
                                                        TextButton(
                                                            child: Text('EDIT'),
                                                            onPressed:
                                                                () async {
                                                              if (_editFormKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                setState(() {
                                                                  _isProcessing =
                                                                      true;
                                                                });

                                                                bool updateUser = await ds.updateId(
                                                                    'username~email~gender~age~namauser~weightgoal~weight~height~caloriestarget~profpic~uid',
                                                                    _usernameTextController.text +
                                                                        '~' +
                                                                        _emailTextController
                                                                            .text +
                                                                        '~' +
                                                                        _gender +
                                                                        '~' +
                                                                        _age
                                                                            .toString() +
                                                                        '~' +
                                                                        _nameTextController
                                                                            .text +
                                                                        '~' +
                                                                        _weightGoal
                                                                            .toString() +
                                                                        '~' +
                                                                        _weightController
                                                                            .text +
                                                                        '~' +
                                                                        _heightController
                                                                            .text +
                                                                        '~' +
                                                                        caloriesTarget
                                                                            .toString() +
                                                                        '~' +
                                                                        profpic +
                                                                        '~' +
                                                                        uid,
                                                                    token,
                                                                    project,
                                                                    'user',
                                                                    appid,
                                                                    _currentUser
                                                                        .uid);

                                                                _nameTextController
                                                                    .text = '';
                                                                _usernameTextController
                                                                    .text = '';
                                                                _emailTextController
                                                                    .text = '';
                                                                _tanggalLahirController
                                                                    .text = '';
                                                                _weightController
                                                                    .text = '';
                                                                _heightController
                                                                    .text = '';

                                                                setState(() {
                                                                  _isProcessing =
                                                                      false;
                                                                });

                                                                if (updateUser) {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              LoginPage()));
                                                                } else {
                                                                  print(
                                                                      'Error Update User');
                                                                }
                                                              }
                                                            }),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text(
                                                'Edit Data',
                                                style: GoogleFonts.rubik(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromARGB(
                                                        255, 250, 250, 250)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDialogPicker(BuildContext context, String curr_tanggalLahir) {
    DateTime date;

    if (curr_tanggalLahir == '') {
      date = DateTime.now();
    } else {
      var inputFormat = DateFormat('d MMMM yyyy');
      date = inputFormat.parse(curr_tanggalLahir);
    }
    selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.utc(date.year, date.month, date.day),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    selectedDate.then((value) {
      if (value == null) return;

      final DateFormat formatter = DateFormat('d MMMM yyyy');
      final String formattedDate = formatter.format(value);

      setState(() {
        _tanggalLahirController.text = formattedDate.toString();
      });
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
