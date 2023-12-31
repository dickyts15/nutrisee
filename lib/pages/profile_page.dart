import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/user_model.dart';
import 'package:nutrisee/pages/login_page.dart';
import 'package:nutrisee/pages/tdee_calculator_result_page.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/restapi.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final String loggedEmail;

  const ProfilePage({super.key, required this.user, required this.loggedEmail});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DataService ds = DataService();
  String saveid = '-';
  String profpic = '-';
  String gender = '-';
  String height = '-';
  String weight = '-';
  int age = 0;
  double bmi = 0;

  late User _currentUser;

  late ValueNotifier<int> _notifier;

  List<UserModel> user = [];

  selectIdUser(String loggedEmail) async {
    List data = [];
    data = jsonDecode(await ds.selectWhere(
        token, project, 'user', appid, 'email', loggedEmail));
    user = data.map((e) => UserModel.fromJson(e)).toList();

    profpic = user[0].profpic;
    saveid = user[0].id;
    gender = user[0].gender;
    height = user[0].height;
    weight = user[0].weight;
    age = int.parse(user[0].age);

    await ds.updateId('uid', _currentUser.uid.toString(), token, project,
        'user', appid, saveid);
  }

  Future reloadDataUser(dynamic value) async {
    setState(() {
      selectIdUser(widget.loggedEmail);
    });
  }

  File? image;
  String? imageProfpic;

  @override
  void initState() {
    _currentUser = widget.user;
    _notifier = ValueNotifier<int>(0);

    super.initState();
  }

  Future pickImage(String id) async {
    try {
      var picked = await FilePicker.platform.pickFiles(withData: true);

      if (picked != null) {
        var respone = await ds.upload(token, project, picked.files.first.bytes!,
            picked.files.first.extension.toString());

        var file = jsonDecode(respone);

        await ds.updateId(
            'profpic', file['file_name'], token, project, 'user', appid, id);

        profpic = file['file_name'];

        _notifier.value++;
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // String resultText = '';
    // String resultStatus = '';
    // if (calculateBMI() < 18.5) {
    //   resultText = 'Underweight';
    //   resultStatus = 'Anda Memiliki Berat Badan Underweight';
    // } else if (calculateBMI() >= 18.5 && calculateBMI() <= 24.9) {
    //   resultText = 'Normal';
    //   resultStatus = 'Anda Memiliki Berat Badan Normal';
    // } else if (calculateBMI() >= 24.9 && calculateBMI() <= 29.9) {
    //   resultText = 'Overweight';
    //   resultStatus = 'Anda Memiliki Berat Badan Overweight';
    // } else if (calculateBMI() >= 30.0) {
    //   resultText = 'Obese';
    //   resultStatus = 'Anda Memiliki Berat Badan Obese';
    // } else {
    //   resultText = 'Invalid';
    //   resultStatus = 'Inputan Invalid';
    // }

    // Color _getResultColor(String resultText) {
    //   switch (resultText) {
    //     case 'Underweight':
    //       return Color.fromARGB(255, 0, 116, 217);
    //     case 'Normal':
    //       return Color.fromARGB(255, 63, 156, 53);
    //     case 'Overweight':
    //       return Color.fromARGB(255, 234, 171, 0);
    //     case 'Obese':
    //       return Color.fromARGB(255, 255, 61, 61);
    //     default:
    //       return Colors.black;
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        ),
        foregroundColor: Color.fromARGB(255, 250, 250, 250),
        backgroundColor: Color.fromARGB(255, 0, 120, 74),
        title: Text('Profile'),
      ),
      body: FutureBuilder<dynamic>(
        future: selectIdUser(widget.loggedEmail),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              {
                return const Text('none');
              }
            case ConnectionState.waiting:
              {
                return const Center(child: CircularProgressIndicator());
              }
            case ConnectionState.active:
              {
                return const Text('Active');
              }
            case ConnectionState.done:
              {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}',
                      style: const TextStyle(color: Colors.red));
                } else {
                  return Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 55),
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        child: Icon(Icons.person),
                                        backgroundImage:
                                            NetworkImage(fileUri + profpic),
                                      ),
                                      InkWell(
                                        onTap: () => pickImage(user[0].id),
                                        child: const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Color.fromARGB(
                                            255,
                                            15,
                                            15,
                                            15,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_outlined,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      '${_currentUser.displayName}',
                                      style: GoogleFonts.rubik(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 21, 21, 21)),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      user[0].username,
                                      style: GoogleFonts.rubik(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 21, 21, 21)),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      user[0].email,
                                      style: GoogleFonts.rubik(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(100, 21, 21, 21)),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${user[0].height} cm',
                                              style: GoogleFonts.rubik(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300,
                                                  color: Color.fromARGB(
                                                      255, 21, 21, 21)),
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              'Tinggi Badan',
                                              style: GoogleFonts.rubik(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300,
                                                  color: Color.fromARGB(
                                                      255, 21, 21, 21)),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 32),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${user[0].weight} kg',
                                              style: GoogleFonts.rubik(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300,
                                                  color: Color.fromARGB(
                                                      255, 21, 21, 21)),
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              'Berat Badan',
                                              style: GoogleFonts.rubik(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300,
                                                  color: Color.fromARGB(
                                                      255, 21, 21, 21)),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 32),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${user[0].age} th',
                                              style: GoogleFonts.rubik(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300,
                                                  color: Color.fromARGB(
                                                      255, 21, 21, 21)),
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              'Usia',
                                              style: GoogleFonts.rubik(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300,
                                                  color: Color.fromARGB(
                                                      255, 21, 21, 21)),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                side: BorderSide(color: Colors.blue),
                                minimumSize: Size(200, 30),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, 'edit_profile',
                                        arguments: [user[0].uid])
                                    .then(selectIdUser(user[0].uid));
                              },
                              child: Text(
                                'Edit Profile',
                                style: GoogleFonts.rubik(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 250, 250, 250)),
                              )),
                          SizedBox(height: 16),
                          Container(
                            height: 5.0,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 16),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Sasaran',
                                  style: GoogleFonts.rubik(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromARGB(
                                          255, 21, 21, 21)),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Berat Badan',
                                  style: GoogleFonts.rubik(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 21, 21, 21)),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${user[0].weightgoal} kg',
                                  style: GoogleFonts.rubik(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 21, 21, 21)),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Aktivitas',
                                  style: GoogleFonts.rubik(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 21, 21, 21)),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${user[0].activity}',
                                  style: GoogleFonts.rubik(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 21, 21, 21)),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Kalori Harian',
                                  style: GoogleFonts.rubik(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 21, 21, 21)),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${user[0].caloriestarget} kal',
                                  style: GoogleFonts.rubik(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 21, 21, 21)),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                          onPrimary: Colors.white,
                                          side: BorderSide(color: Colors.blue),
                                          minimumSize: Size(237, 58),
                                        ),
                                        onPressed: () async {
                                          Navigator.pushNamed(
                                              context, 'edit_sasaran',
                                              arguments: [user[0].uid]);
                                        },
                                        child: Text(
                                          'Edit Sasaran',
                                          style: GoogleFonts.rubik(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(
                                                  255, 250, 250, 250)),
                                        )),
                                    SizedBox(width: 16.0),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                          onPrimary: Colors.white,
                                          side: BorderSide(color: Colors.blue),
                                          minimumSize: Size(237, 58),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TDEECalculatorResultPage(
                                                      umur: int.parse(
                                                          user[0].age),
                                                      tinggi: double.parse(
                                                          user[0].height),
                                                      berat: double.parse(
                                                          user[0].weight),
                                                      aktivitas:
                                                          'Sedentary (Office job)',
                                                      bodyfat:
                                                          double.parse('15'),
                                                      gender: user[0].gender),
                                            ),
                                          );
                                        },
                                        child: Text('Periksa TDEE',
                                            style: GoogleFonts.rubik(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromARGB(
                                                    255, 250, 250, 250)))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            height: 5.0,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 16.0),
                          // Padding(
                          //   padding: EdgeInsets.all(16.0),
                          //   child: Text(
                          //     'Status BMI',
                          //     textAlign: TextAlign.justify,
                          //     style: GoogleFonts.rubik(
                          //       fontSize: 48,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          // Card(
                          //   color: Color.fromARGB(255, 229, 229, 229),
                          //   margin: EdgeInsets.only(left: 16.0, right: 16.0),
                          //   child: Padding(
                          //     padding: EdgeInsets.all(16.0),
                          //     child: Column(
                          //       children: [
                          //         Container(
                          //           padding: EdgeInsets.all(4.0),
                          //           child: Column(
                          //             children: [
                          //               Text(
                          //                 resultText,
                          //                 style: GoogleFonts.crimsonPro(
                          //                     fontWeight: FontWeight.bold,
                          //                     fontSize: 24.0,
                          //                     color:
                          //                         _getResultColor(resultText)),
                          //               ),
                          //               SizedBox(height: 16.0),
                          //               Text(
                          //                 calculateBMI().toStringAsFixed(1),
                          //                 style: GoogleFonts.crimsonPro(
                          //                     fontWeight: FontWeight.bold,
                          //                     fontSize: 64.0,
                          //                     color: Color.fromARGB(
                          //                         255, 15, 15, 15)),
                          //               ),
                          //               SizedBox(height: 16.0),
                          //               Text(
                          //                 resultStatus,
                          //                 style: GoogleFonts.crimsonPro(
                          //                     fontWeight: FontWeight.bold,
                          //                     fontSize: 16.0,
                          //                     color: Color.fromARGB(
                          //                         255, 15, 15, 15)),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                }
              }
          }
        },
      ),
    );
  }

  // double calculateBMI() {
  //   double bmi = double.parse(weight) /
  //       ((double.parse(height) * 0.01) * (double.parse(height) * 0.01));
  //   return bmi;
  // }
}
