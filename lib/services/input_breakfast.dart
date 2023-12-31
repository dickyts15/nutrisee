import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/breakfast_model.dart';
import 'package:nutrisee/pages/buku_harian_page.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/restapi.dart';
import 'package:intl/intl.dart';
import 'package:nutrisee/utils/validator.dart';

class InputBreakfast extends StatefulWidget {
  final User user;
  final String currDate;

  const InputBreakfast({super.key, required this.user, required this.currDate});
  @override
  _InputBreakfastState createState() => _InputBreakfastState();
}

class _InputBreakfastState extends State<InputBreakfast> {
  DataService ds = DataService();
  final _makananKey = GlobalKey<FormState>();
  final _namaBreakfastController = TextEditingController();
  final _quantityController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _proteinController = TextEditingController();

  final _focusNamaBreakfast = FocusNode();
  final _focusQuantity = FocusNode();
  final _focusCarbs = FocusNode();
  final _focusFat = FocusNode();
  final _focusProtein = FocusNode();

  String createdDate = '';
  late User loggedInUser;
  bool _isProcessing = false;

  void initState() {
    super.initState();
    loggedInUser = widget.user;
    createdDate = widget.currDate;
  }

  @override
  Widget build(BuildContext context) {
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
                  'Input Data Breakfast',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _namaBreakfastController,
                  validator: (value) => Validator.validateName(name: value),
                  decoration: InputDecoration(labelText: 'Nama Breakfast'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _quantityController,
                  validator: (value) => Validator.validateNumber(number: value),
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _carbsController,
                  validator: (value) => Validator.validateNumber(number: value),
                  decoration: InputDecoration(labelText: 'Carbs'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _fatController,
                  validator: (value) => Validator.validateNumber(number: value),
                  decoration: InputDecoration(labelText: 'Fat'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _proteinController,
                  validator: (value) => Validator.validateNumber(number: value),
                  decoration: InputDecoration(labelText: 'Protein'),
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
                                _focusNamaBreakfast.unfocus();
                                _focusQuantity.unfocus();
                                _focusCarbs.unfocus();
                                _focusFat.unfocus();
                                _focusProtein.unfocus();

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
                                      await ds.insertBreakfast(
                                          appid,
                                          _namaBreakfastController.text,
                                          _quantityController.text,
                                          calories.toString(),
                                          _carbsController.text,
                                          _fatController.text,
                                          _proteinController.text,
                                          createdDate.toString(),
                                          loggedInUser.uid));

                                  List<BreakfastModel> breakfast = response
                                      .map((e) => BreakfastModel.fromJson(e))
                                      .toList();

                                  setState(() {
                                    _isProcessing = false;
                                  });

                                  if (breakfast.length == 1) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BukuHarianPage(
                                                    user: loggedInUser,
                                                    loggedEmail: loggedInUser
                                                        .email
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
                                'Input Breakfast',
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
