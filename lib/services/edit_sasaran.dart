import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/user_model.dart';
import 'package:nutrisee/pages/login_page.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/restapi.dart';

class EditSasaran extends StatefulWidget {
  const EditSasaran({super.key});

  @override
  State<EditSasaran> createState() => _EditSasaranState();
}

class _EditSasaranState extends State<EditSasaran> {
  DataService ds = DataService();
  final _sasaranKey = GlobalKey<FormState>();
  final _weightGoalController = TextEditingController();
  String _aktivitas = 'Sedentary (office job)';

  final _focusWeightGoal = FocusNode();

  String id = '-';
  String gender = '-';
  String height = '-';
  String weight = '-';
  int age = 0;

  late User loggedInUser;
  bool _isProcessing = false;
  bool loadData = false;

  List<UserModel> user = [];

  selectIdUser(String uid) async {
    List data = [];
    data = jsonDecode(
        await ds.selectWhere(token, project, 'user', appid, 'uid', uid));
    user = data.map((e) => UserModel.fromJson(e)).toList();

    setState(() {
      user = user;
      _aktivitas = user[0].activity;
      _weightGoalController.text = user[0].weightgoal;
      gender = user[0].gender;
      height = user[0].height;
      weight = user[0].weight;
      age = int.parse(user[0].age);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;

    if (loadData == false) {
      selectIdUser(args[0]);

      loadData = true;
    }
    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            right: 0,
            top: 0,
            child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close)),
          ),
          Form(
            key: _sasaranKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Edit Sasaran',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _weightGoalController,
                  decoration: InputDecoration(labelText: 'Berat Badan'),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: DropdownButton(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    borderRadius: BorderRadius.circular(16.0),
                    value: _aktivitas,
                    items: [
                      DropdownMenuItem(
                        value: 'Sedentary (office job)',
                        child: Text(
                          'Sedentary (office job)',
                          style: GoogleFonts.rubik(
                            color: Color.fromARGB(255, 21, 21, 21),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Light Exercise',
                        child: Text(
                          'Light Exercise (1-2 days/week)',
                          style: GoogleFonts.rubik(
                            color: Color.fromARGB(255, 21, 21, 21),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Moderate Exercise',
                        child: Text(
                          'Moderate Exercise (3-5 days/week)',
                          style: GoogleFonts.rubik(
                            color: Color.fromARGB(255, 21, 21, 21),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Heavy Exercise',
                        child: Text(
                          'Heavy Exercise',
                          style: GoogleFonts.rubik(
                            color: Color.fromARGB(255, 21, 21, 21),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Athlete',
                        child: Text(
                          'Athlete (2x per day)',
                          style: GoogleFonts.rubik(
                            color: Color.fromARGB(255, 21, 21, 21),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _aktivitas = value.toString();
                      });
                    },
                    hint: Text('Pilih Aktivitas'),
                  ),
                ),
                SizedBox(height: 20),
                _isProcessing
                    ? const CircularProgressIndicator()
                    : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Warning"),
                                      content: Text("Edit Sasaran?"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('CANCEL'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('EDIT'),
                                          onPressed: () async {
                                            _focusWeightGoal.unfocus();

                                            if (_sasaranKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _isProcessing = true;
                                              });

                                              bool updateSasaran =
                                                  await ds.updateId(
                                                      'weightgoal~caloriestarget~activity',
                                                      _weightGoalController
                                                              .text +
                                                          '~' +
                                                          resultDailyCalories()
                                                              .toStringAsFixed(
                                                                  0) +
                                                          '~' +
                                                          _aktivitas,
                                                      token,
                                                      project,
                                                      'user',
                                                      appid,
                                                      user[0].id);

                                              setState(() {
                                                _isProcessing = false;
                                              });

                                              if (updateSasaran) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage()));
                                              } else {
                                                if (kDebugMode) {
                                                  print('Error Update Sasaran');
                                                }
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Edit Sasaran'),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double resultDailyCalories() {
    double result = 0.0;
    if (gender == 'Laki-laki') {
      result =
          (10 * int.parse(weight)) + (6.25 * int.parse(height)) - (5 * age) + 5;
    } else if (gender == 'Perempuan') {
      result = (10 * int.parse(weight)) +
          (6.25 * int.parse(height)) -
          (5 * age) -
          161;
    } else {
      result = 0;
    }
    if (_aktivitas == 'Sedentary (office job)') {
      result = result * 1.2;
    } else if (_aktivitas == 'Light Exercise') {
      result = result * 1.375;
    } else if (_aktivitas == 'Moderate Exercise') {
      result = result * 1.55;
    } else if (_aktivitas == 'Heavy Exercise') {
      result = result * 1.725;
    } else if (_aktivitas == 'Athlete') {
      result = result * 1.9;
    } else {
      result = result;
    }
    return result;
  }
}
