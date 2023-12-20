import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/Lunch_model.dart';
import 'package:nutrisee/component/models/latihan_model.dart';
import 'package:nutrisee/component/models/user_model.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/firebase_auth.dart';
import 'package:nutrisee/utils/restapi.dart';

class InputLunch extends StatefulWidget {
  final User user;

  const InputLunch({super.key, required this.user});
  @override
  _InputLunchState createState() => _InputLunchState();
}

class _InputLunchState extends State<InputLunch> {
  DataService ds = DataService();
  final _makananKey = GlobalKey<FormState>();
  final _namaLunchController = TextEditingController();
  final _quantityController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _proteinController = TextEditingController();
  final _dateController = TextEditingController();

  final _focusNamaLunch = FocusNode();
  final _focusQuantity = FocusNode();
  final _focusCarbs = FocusNode();
  final _focusFat = FocusNode();
  final _focusProtein = FocusNode();
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
            key: _makananKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Input Data Lunch',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _namaLunchController,
                  decoration: InputDecoration(labelText: 'Nama Lunch'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _carbsController,
                  decoration: InputDecoration(labelText: 'Carbs'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _fatController,
                  decoration: InputDecoration(labelText: 'Fat'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _proteinController,
                  decoration: InputDecoration(labelText: 'Protein'),
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
                                _focusNamaLunch.unfocus();
                                _focusQuantity.unfocus();
                                _focusCarbs.unfocus();
                                _focusFat.unfocus();
                                _focusProtein.unfocus();
                                _focusDate.unfocus();

                                if (_makananKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  double calories = ((double.parse(
                                              _carbsController.text)) *
                                          4) +
                                      ((double.parse(_fatController.text)) *
                                          9) +
                                      ((double.parse(_proteinController.text)) *
                                          4);

                                  List response = jsonDecode(
                                      await ds.insertLunch(
                                          appid,
                                          _namaLunchController.text,
                                          _quantityController.text,
                                          calories.toString(),
                                          _carbsController.text,
                                          _fatController.text,
                                          _proteinController.text,
                                          _dateController.text,
                                          loggedInUser.uid));

                                  List<LunchModel> Lunch = response
                                      .map((e) => LunchModel.fromJson(e))
                                      .toList();

                                  setState(() {
                                    _isProcessing = false;
                                  });

                                  if (Lunch != null && Lunch.length == 1) {
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
                                'Input Lunch',
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
