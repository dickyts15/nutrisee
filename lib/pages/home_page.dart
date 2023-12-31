import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/breakfast_model.dart';
import 'package:nutrisee/component/models/dinner_model.dart';
import 'package:nutrisee/component/models/latihan_model.dart';
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
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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

  List dataBreakfast = [];
  List dataLunch = [];
  List dataDinner = [];
  List dataSnack = [];
  List dataLatihan = [];
  List<BreakfastModel> breakfast = [];
  List<LunchModel> lunch = [];
  List<DinnerModel> dinner = [];
  List<SnackModel> snack = [];
  List<LatihanModel> latihan = [];

  selectAllData() async {
    dataBreakfast = jsonDecode(await ds.selectWhere(
        token, project, 'breakfast', appid, 'uid', _currentUser.uid));
    breakfast = dataBreakfast.map((e) => BreakfastModel.fromJson(e)).toList();

    dataLunch = jsonDecode(await ds.selectWhere(
        token, project, 'lunch', appid, 'uid', _currentUser.uid));
    lunch = dataLunch.map((e) => LunchModel.fromJson(e)).toList();

    dataDinner = jsonDecode(await ds.selectWhere(
        token, project, 'dinner', appid, 'uid', _currentUser.uid));
    dinner = dataDinner.map((e) => DinnerModel.fromJson(e)).toList();

    dataSnack = jsonDecode(await ds.selectWhere(
        token, project, 'snack', appid, 'uid', _currentUser.uid));
    snack = dataSnack.map((e) => SnackModel.fromJson(e)).toList();

    dataLatihan = jsonDecode(await ds.selectWhere(
        token, project, 'latihan', appid, 'uid', _currentUser.uid));
    latihan = dataLatihan.map((e) => LatihanModel.fromJson(e)).toList();

    setState(() {
      breakfast = breakfast;
      lunch = lunch;
      dinner = dinner;
      snack = snack;
      latihan = latihan;
    });
  }

  List<LatihanModel> latihanCurrDate = [];
  List<BreakfastModel> breakfastCurrDate = [];
  List<LunchModel> lunchCurrDate = [];
  List<DinnerModel> dinnerCurrDate = [];
  List<SnackModel> snackCurrDate = [];
  List<LatihanModel> latihanCurrDate_pre = [];
  List<BreakfastModel> breakfastCurrDate_pre = [];
  List<LunchModel> lunchCurrDate_pre = [];
  List<DinnerModel> dinnerCurrDate_pre = [];
  List<SnackModel> snackCurrDate_pre = [];

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
    int sumMakanan = 0;
    sumMakanan = sum(breakfastCurrDate) +
        sum(lunchCurrDate) +
        sum(dinnerCurrDate) +
        sum(snackCurrDate);
    return sumMakanan;
  }

  String currentDate = '';

  void filterDataLatihan(String date) {
    if (date.isEmpty) {
      latihanCurrDate =
          dataLatihan.map((e) => LatihanModel.fromJson(e)).toList();
    } else {
      latihanCurrDate_pre =
          dataLatihan.map((e) => LatihanModel.fromJson(e)).toList();

      latihanCurrDate = latihanCurrDate_pre
          .where((latihan) => latihan.date.contains(date))
          .toList();
    }

    // Refresh the UI
    setState(() {
      latihanCurrDate = latihanCurrDate;
      currentDate = date;
    });
  }

  void filterDataBreakfast(String date) {
    if (date.isEmpty) {
      breakfastCurrDate =
          dataBreakfast.map((e) => BreakfastModel.fromJson(e)).toList();
    } else {
      breakfastCurrDate_pre =
          dataBreakfast.map((e) => BreakfastModel.fromJson(e)).toList();

      breakfastCurrDate = breakfastCurrDate_pre
          .where((breakfast) => breakfast.date.contains(date))
          .toList();
    }

    // Refresh the UI
    setState(() {
      breakfastCurrDate = breakfastCurrDate;
    });
  }

  void filterDataLunch(String date) {
    if (date.isEmpty) {
      lunchCurrDate = dataLunch.map((e) => LunchModel.fromJson(e)).toList();
    } else {
      lunchCurrDate_pre = dataLunch.map((e) => LunchModel.fromJson(e)).toList();

      lunchCurrDate = lunchCurrDate_pre
          .where((lunch) => lunch.date.contains(date))
          .toList();
    }

    // Refresh the UI
    setState(() {
      lunchCurrDate = lunchCurrDate;
    });
  }

  void filterDataDinner(String date) {
    if (date.isEmpty) {
      dinnerCurrDate = dataDinner.map((e) => DinnerModel.fromJson(e)).toList();
    } else {
      dinnerCurrDate_pre =
          dataDinner.map((e) => DinnerModel.fromJson(e)).toList();

      dinnerCurrDate = dinnerCurrDate_pre
          .where((dinner) => dinner.date.contains(date))
          .toList();
    }

    // Refresh the UI
    setState(() {
      dinnerCurrDate = dinnerCurrDate;
    });
  }

  void filterDataSnack(String date) {
    if (date.isEmpty) {
      snackCurrDate = dataSnack.map((e) => SnackModel.fromJson(e)).toList();
    } else {
      snackCurrDate_pre = dataSnack.map((e) => SnackModel.fromJson(e)).toList();

      snackCurrDate = snackCurrDate_pre
          .where((snack) => snack.date.contains(date))
          .toList();
    }

    // Refresh the UI
    setState(() {
      snackCurrDate = snackCurrDate;
    });
  }

  int jumlahCaloriesMakanan = 0;
  @override
  void initState() {
    _currentUser = widget.user;

    _initializeData();
    _notifier = ValueNotifier<int>(0);
    super.initState();
  }

  void _initializeData() async {
    await selectAllData();
    filterDataLatihan(_dateFormatter(DateTime.now()));
    filterDataBreakfast(_dateFormatter(DateTime.now()));
    filterDataLunch(_dateFormatter(DateTime.now()));
    filterDataDinner(_dateFormatter(DateTime.now()));
    filterDataSnack(_dateFormatter(DateTime.now()));
    sumMakanan();
    jumlahCaloriesMakanan = sumMakanan();
    _notifier = ValueNotifier<int>(0);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showAlert();
    });
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
                                                    'Status Kalori',
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
                                                    _dateFormatter(
                                                        DateTime.now()),
                                                    style: GoogleFonts.rubik(
                                                        fontSize: 16.0,
                                                        color: Colors.grey),
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
                                                              (int.parse(user[0]
                                                                          .caloriestarget) -
                                                                      sumMakanan() +
                                                                      sum(latihanCurrDate))
                                                                  .toString(),
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
                                                                sum(latihanCurrDate)
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
                                                onPressed: () async {
                                                  Navigator.pushNamed(
                                                      context, 'edit_sasaran',
                                                      arguments: [user[0].uid]);
                                                },
                                                child: Text(
                                                  'Edit Sasaran',
                                                )),
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
                                                        sum(latihanCurrDate)
                                                            .toString(),
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
                                                                          _currentUser,
                                                                      currDate:
                                                                          _dateFormatter(
                                                                              DateTime.now())));
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
                                                        sumMakanan().toString(),
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
          data is SnackModel ||
          data is LatihanModel) {
        return total + int.parse(data.calories);
      } else {
        return total;
      }
    });
  }

  String _dateFormatter(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    String month;

    switch (tm.month) {
      case 1:
        month = "1";
        break;
      case 2:
        month = "2";
        break;
      case 3:
        month = "3";
        break;
      case 4:
        month = "4";
        break;
      case 5:
        month = "5";
        break;
      case 6:
        month = "6";
        break;
      case 7:
        month = "7";
        break;
      case 8:
        month = "8";
        break;
      case 9:
        month = "9";
        break;
      case 10:
        month = "10";
        break;
      case 11:
        month = "11";
        break;
      case 12:
        month = "12";
        break;
      default:
        month = "Undefined";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "${tm.year}-$month-${tm.day}";
    } else if (difference.compareTo(twoDay) < 1) {
      return "${tm.year}-$month-${tm.day}";
    } else {
      return "${tm.year}-$month-${tm.day}";
    }
  }

  Future<void> showAlert() async {
    if (sumMakanan() == 0) {
      return QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'Kalori Harian',
        text: 'Anda Belum Menambahkan Makanan Hari ini. Tambahkan Sekarang?',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
    } else {}
  }
}
