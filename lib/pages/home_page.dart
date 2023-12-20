import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/breakfast_model.dart';
import 'package:nutrisee/component/models/dinner_model.dart';
import 'package:nutrisee/component/models/lunch_model.dart';
import 'package:nutrisee/component/models/snack_model.dart';
import 'package:nutrisee/component/models/user_model.dart';
import 'package:nutrisee/pages/bmi_calculator_input_page.dart';
import 'package:nutrisee/pages/buku_harian_page.dart';
import 'package:nutrisee/pages/macronutrient_calculator_input_page.dart';
import 'package:nutrisee/pages/profile_page.dart';
import 'package:nutrisee/pages/tdee_calculator_input_page.dart';
import 'package:nutrisee/pages/welcome_page.dart';
import 'package:nutrisee/services/input_latihan.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/restapi.dart';

class HomePage extends StatefulWidget {
  final User user;
  final String loggedEmail;

  const HomePage({super.key, required this.user, required this.loggedEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataService ds = DataService();

  String saveid = '-';
  String profpic = '-';

  late User _currentUser;

  late ValueNotifier<int> _notifier;

  List data = [];
  List<UserModel> user = [];
  List<BreakfastModel> breakfast = [];
  List<LunchModel> lunch = [];
  List<DinnerModel> dinner = [];
  List<SnackModel> snack = [];

  selectAllFoods() async {
    data = jsonDecode(await ds.selectWhere(
        token, project, 'breakfast', appid, 'uid', _currentUser.uid));
    breakfast = data.map((e) => BreakfastModel.fromJson(e)).toList();

    data = jsonDecode(await ds.selectWhere(
        token, project, 'lunch', appid, 'uid', _currentUser.uid));
    lunch = data.map((e) => LunchModel.fromJson(e)).toList();

    data = jsonDecode(await ds.selectWhere(
        token, project, 'dinner', appid, 'uid', _currentUser.uid));
    dinner = data.map((e) => DinnerModel.fromJson(e)).toList();

    data = jsonDecode(await ds.selectWhere(
        token, project, 'snack', appid, 'uid', _currentUser.uid));
    snack = data.map((e) => SnackModel.fromJson(e)).toList();

    setState(() {
      breakfast = breakfast;
      lunch = lunch;
      dinner = dinner;
      snack = snack;
    });
  }

  selectIdUser(String loggedEmail) async {
    List data = [];
    data = jsonDecode(await ds.selectWhere(
        token, project, 'user', appid, 'email', loggedEmail));
    user = data.map((e) => UserModel.fromJson(e)).toList();

    profpic = user[0].profpic;
    saveid = user[0].id;

    await ds.updateId('uid', _currentUser.uid.toString(), token, project,
        'user', appid, saveid);
  }

  Future reloadDataUser(dynamic value) async {
    setState(() {
      selectIdUser(widget.loggedEmail);
    });
  }

  int sumMakanan() {
    int sumMakanan = sum(breakfast) + sum(lunch) + sum(dinner) + sum(snack);
    return sumMakanan;
  }

  @override
  void initState() {
    _currentUser = widget.user;
    _notifier = ValueNotifier<int>(0);
    super.initState();
  }

  File? image;
  String? imageProfpic;

  @override
  Widget build(BuildContext context) => FutureBuilder<dynamic>(
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
                    backgroundColor: Color.fromARGB(255, 250, 250, 250),
                    appBar: AppBar(
                      title: Text('Nutrisee'),
                      foregroundColor: Color.fromARGB(255, 250, 250, 250),
                      backgroundColor: Color.fromARGB(255, 0, 120, 74),
                    ),
                    drawer: Drawer(
                      backgroundColor: Color.fromARGB(255, 250, 250, 250),
                      child: ListView(
                        children: <Widget>[
                          UserAccountsDrawerHeader(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 120, 74)),
                            accountName: Text('${user[0].namauser}',
                                style: GoogleFonts.rubik()),
                            accountEmail: Text('${user[0].email}',
                                style: GoogleFonts.rubik()),
                            currentAccountPicture: CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.person),
                              backgroundImage: NetworkImage(fileUri + profpic),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Nutrisee',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rubik(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          ListTile(
                            leading: Icon(Icons.home),
                            title: Text('Home', style: GoogleFonts.rubik()),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.menu_book),
                            title:
                                Text('Buku Harian', style: GoogleFonts.rubik()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BukuHarianPage(
                                          user: _currentUser,
                                          loggedEmail: user[0].email,
                                        )),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.content_paste_search_outlined),
                            title: Text('BMI Calculator',
                                style: GoogleFonts.rubik()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BMICalculatorInputPage()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.run_circle_outlined),
                            title: Text('TDEE Calculator',
                                style: GoogleFonts.rubik()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TDEECalculatorInputPage()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.food_bank_sharp),
                            title: Text('Macronutrients Calculator',
                                style: GoogleFonts.rubik()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MacronutrientCalculatorInputPage()),
                              );
                            },
                          ),
                          Divider(color: Colors.grey),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Profile Page',
                                style: GoogleFonts.rubik()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          user: _currentUser,
                                          loggedEmail: user[0].email,
                                        )),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text(
                              'Logout',
                              style: GoogleFonts.rubik(),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Konfirmasi Sign Out'),
                                    content: Text('Anda yakin ingin keluar?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Tutup dialog
                                        },
                                        child: Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await FirebaseAuth.instance.signOut();

                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const WelcomePage(),
                                            ),
                                          );
                                        },
                                        child: Text('Ya, Keluar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
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
                              return const Center(
                                  child: CircularProgressIndicator());
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
                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 8.0),
                                      Center(
                                        child: Text(
                                          'Hello, ${user[0].namauser}!',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rubik(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          'Welcome to Nutrisee',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rubik(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        color: Color.fromARGB(255, 0, 120, 74),
                                        margin: EdgeInsets.all(32.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Kalori',
                                                    style: GoogleFonts.rubik(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 24.0,
                                                        color: Color.fromARGB(
                                                            255,
                                                            250,
                                                            250,
                                                            250)),
                                                  ),
                                                  Text(
                                                      'Sisa = Sasaran - Makanan + Latihan',
                                                      style: GoogleFonts
                                                          .crimsonPro(
                                                        color: Color.fromARGB(
                                                            255, 250, 250, 250),
                                                        fontSize: 24.0,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Divider(color: Colors.grey),
                                            Container(
                                              padding: EdgeInsets.all(16.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: 100.0,
                                                        height: 100.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          250,
                                                                          250,
                                                                          250),
                                                                  width: 4.0,
                                                                )),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              '${user[0].caloriestarget}',
                                                              style: GoogleFonts.rubik(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          250,
                                                                          250,
                                                                          250),
                                                                  fontSize:
                                                                      24.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              'Tersisa',
                                                              style: GoogleFonts.rubik(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          250,
                                                                          250,
                                                                          250),
                                                                  fontSize:
                                                                      12.0),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(width: 64.0),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .flag_rounded,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              SizedBox(
                                                                  height: 24.0),
                                                              Icon(
                                                                  Icons
                                                                      .fastfood,
                                                                  color: Colors
                                                                      .lightBlue),
                                                              SizedBox(
                                                                  height: 24.0),
                                                              Icon(
                                                                Icons
                                                                    .directions_run_sharp,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(width: 8.0),
                                                          Column(
                                                            children: [
                                                              Text(
                                                                'Sasaran Kalori',
                                                                style:
                                                                    GoogleFonts
                                                                        .rubik(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          250,
                                                                          250,
                                                                          250),
                                                                ),
                                                              ),
                                                              Text(
                                                                '${user[0].caloriestarget}',
                                                                style: GoogleFonts
                                                                    .crimsonPro(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          250,
                                                                          250,
                                                                          250),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Makanan',
                                                                style:
                                                                    GoogleFonts
                                                                        .rubik(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          250,
                                                                          250,
                                                                          250),
                                                                ),
                                                              ),
                                                              Text(
                                                                sumMakanan()
                                                                    .toString(),
                                                                style: GoogleFonts
                                                                    .crimsonPro(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          250,
                                                                          250,
                                                                          250),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Latihan',
                                                                style:
                                                                    GoogleFonts
                                                                        .rubik(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          250,
                                                                          250,
                                                                          250),
                                                                ),
                                                              ),
                                                              Text(
                                                                '0',
                                                                style: GoogleFonts
                                                                    .crimsonPro(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          250,
                                                                          250,
                                                                          250),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfilePage(
                                                                  user:
                                                                      _currentUser,
                                                                  loggedEmail:
                                                                      _currentUser
                                                                          .email
                                                                          .toString())));
                                                },
                                                child: Text('Edit Target')),
                                            SizedBox(height: 8),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Card(
                                            color:
                                                Color.fromARGB(255, 0, 120, 74),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .directions_run_sharp,
                                                          size: 32.0,
                                                          color: Colors.orange),
                                                      Text(
                                                        'Latihan',
                                                        style:
                                                            GoogleFonts.rubik(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 24.0,
                                                          color: Color.fromARGB(
                                                              255,
                                                              250,
                                                              250,
                                                              250),
                                                        ),
                                                      ),
                                                      Text(
                                                        '0',
                                                        style: GoogleFonts
                                                            .crimsonPro(
                                                          color: Color.fromARGB(
                                                              255,
                                                              250,
                                                              250,
                                                              250),
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          await showDialog<
                                                                  void>(
                                                              context: context,
                                                              builder: (context) =>
                                                                  InputLatihan(
                                                                      user:
                                                                          _currentUser));
                                                        },
                                                        child: Text(
                                                            'Tambahkan Latihan'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Card(
                                            color:
                                                Color.fromARGB(255, 0, 120, 74),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Column(
                                                    children: [
                                                      Icon(Icons.fastfood,
                                                          size: 32.0,
                                                          color:
                                                              Colors.lightBlue),
                                                      Text(
                                                        'Makanan',
                                                        style:
                                                            GoogleFonts.rubik(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 24.0,
                                                          color: Color.fromARGB(
                                                              255,
                                                              250,
                                                              250,
                                                              250),
                                                        ),
                                                      ),
                                                      Text(
                                                        '0',
                                                        style: GoogleFonts
                                                            .crimsonPro(
                                                          color: Color.fromARGB(
                                                              255,
                                                              250,
                                                              250,
                                                              250),
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BukuHarianPage(
                                                                user:
                                                                    _currentUser,
                                                                loggedEmail:
                                                                    user[0]
                                                                        .email,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                            'Tambahkan Makanan'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.0),
                                    ],
                                  ),
                                );
                              }
                            }
                        }
                      },
                    ),
                  );
                }
              }
          }
        },
      );
  int sum(List<dynamic> data) {
    return data.fold(0, (total, data) {
      if (data is BreakfastModel ||
          data is LunchModel ||
          data is DinnerModel ||
          data is SnackModel) {
        return total + int.parse(data.calories);
      } else {
        return total;
      }
    });
  }
}
