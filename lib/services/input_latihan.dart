import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/latihan_model.dart';
import 'package:nutrisee/pages/home_page.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/restapi.dart';
import 'package:intl/intl.dart';
import 'package:nutrisee/utils/validator.dart';

class InputLatihan extends StatefulWidget {
  final User user;
  final String currDate;

  const InputLatihan({super.key, required this.user, required this.currDate});
  @override
  _InputLatihanState createState() => _InputLatihanState();
}

class _InputLatihanState extends State<InputLatihan> {
  DataService ds = DataService();
  final _latihanKey = GlobalKey<FormState>();
  final _namaLatihanController = TextEditingController();
  final _caloriesController = TextEditingController();

  final _focusNamaLatihan = FocusNode();
  final _focusCalories = FocusNode();
  final _focusDate = FocusNode();

  String createdDate = '';
  late User loggedInUser;
  bool _isProcessing = false;

  final _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
    loggedInUser = widget.user;
    createdDate = widget.currDate;
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    DataService ds = DataService();

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
            key: _latihanKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Input Data Latihan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _namaLatihanController,
                  validator: (value) => Validator.validateName(name: value),
                  decoration: InputDecoration(labelText: 'Nama Latihan'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _caloriesController,
                  validator: (value) => Validator.validateNumber(number: value),
                  decoration: InputDecoration(labelText: 'Calories'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                _isProcessing
                    ? const CircularProgressIndicator()
                    : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                _focusNamaLatihan.unfocus();
                                _focusCalories.unfocus();
                                _focusDate.unfocus();

                                if (_latihanKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  List response = jsonDecode(
                                      await ds.insertLatihan(
                                          appid,
                                          _namaLatihanController.text,
                                          _caloriesController.text,
                                          createdDate.toString(),
                                          loggedInUser.uid));

                                  List<LatihanModel> latihan = response
                                      .map((e) => LatihanModel.fromJson(e))
                                      .toList();

                                  setState(() {
                                    _isProcessing = false;
                                  });

                                  if (latihan.length == 1) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                user: loggedInUser,
                                                loggedEmail: loggedInUser.email
                                                    .toString())));
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
                                'Input Latihan',
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
        ],
      ),
    );
  }
}
