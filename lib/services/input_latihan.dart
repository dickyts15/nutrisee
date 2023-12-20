import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/latihan_model.dart';
import 'package:nutrisee/component/models/user_model.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/firebase_auth.dart';
import 'package:nutrisee/utils/restapi.dart';

class InputLatihan extends StatefulWidget {
  final User user;

  const InputLatihan({super.key, required this.user});
  @override
  _InputLatihanState createState() => _InputLatihanState();
}

class _InputLatihanState extends State<InputLatihan> {
  DataService ds = DataService();
  final _latihanKey = GlobalKey<FormState>();
  final _namaLatihanController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _dateController = TextEditingController();

  final _focusNamaLatihan = FocusNode();
  final _focusCalories = FocusNode();
  final _focusDate = FocusNode();

  late User loggedInUser;
  bool _isProcessing = false;

  final _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
    loggedInUser = widget.user;
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
                  decoration: InputDecoration(labelText: 'Nama Latihan'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _caloriesController,
                  decoration: InputDecoration(labelText: 'Calories'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _dateController,
                  decoration:
                      InputDecoration(labelText: 'Tanggal (YYYY-MM-DD)'),
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
                                          _dateController.text,
                                          loggedInUser.uid));

                                  List<LatihanModel> latihan = response
                                      .map((e) => LatihanModel.fromJson(e))
                                      .toList();

                                  setState(() {
                                    _isProcessing = false;
                                  });

                                  if (latihan != null && latihan.length == 1) {
                                    Navigator.pop(context);
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
