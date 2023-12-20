import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrisee/component/models/breakfast_model.dart';
import 'package:nutrisee/component/models/dinner_model.dart';
import 'package:nutrisee/component/models/lunch_model.dart';
import 'package:nutrisee/component/models/snack_model.dart';
import 'package:nutrisee/component/models/user_model.dart';
import 'package:nutrisee/services/input_breakfast.dart';
import 'package:nutrisee/services/input_dinner.dart';
import 'package:nutrisee/services/input_lunch.dart';
import 'package:nutrisee/services/input_snack.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/restapi.dart';

class BukuHarian1 extends StatefulWidget {
  final User user;
  final String loggedEmail;
  const BukuHarian1({super.key, required this.user, required this.loggedEmail});

  @override
  State<BukuHarian1> createState() => _BukuHarian1State();
}

class _BukuHarian1State extends State<BukuHarian1> {
  DataService ds = DataService();
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
  }

  Future reloadDataUser(dynamic value) async {
    setState(() {
      selectIdUser(widget.loggedEmail);
    });
  }

  Future reloadDataFood(dynamic value) async {
    setState(() {
      selectAllFoods();
    });
  }

  @override
  void initState() {
    _currentUser = widget.user;
    _notifier = ValueNotifier<int>(0);
    selectAllFoods();
    super.initState();
  }

  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();
  Color _rightArrowColor = Colors.grey;
  Color _leftArrowColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: Column(
          children: <Widget>[
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     _showDatePicker(),
            //   ],
            // ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Sasaran Kalori',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildInfoWidget('2.030'),
                _buildIconWidget(Icons.remove),
                _buildInfoWidget('0'),
                _buildIconWidget(Icons.add),
                _buildInfoWidget('0'),
                _buildInfoWidget('='),
                _buildInfoWidget('2.030'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildLabelWidget('Sasaran'),
                _buildLabelWidget(''),
                _buildLabelWidget('Makanan'),
                _buildLabelWidget(''),
                _buildLabelWidget('Latihan'),
                _buildLabelWidget(''),
                _buildLabelWidget('Sisa'),
              ],
            ),
            SizedBox(height: 8),
            Container(
              height: 5.0,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 2.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.white,
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Color.fromARGB(255, 0, 120, 74),
                    child: Column(
                      children: <Widget>[
                        const ListTile(
                          title: Text('Sarapan'),
                          trailing: Text(
                            '500',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: breakfast.length,
                    itemBuilder: (context, index) {
                      final item = breakfast[index];

                      return Container(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(item.namabreakfast),
                                    subtitle: Text('${item.quantity} gr'),
                                    trailing: Text(item.calories),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: IconButton(
                            onPressed: () async {
                              await showDialog<void>(
                                  context: context,
                                  builder: (context) =>
                                      InputBreakfast(user: _currentUser));
                            },
                            icon: Icon(Icons.add),
                          ),
                          title: Text(
                            'Tambah Makanan',
                          ),
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 5.0,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
                child: Column(
              children: <Widget>[
                Container(
                  color: Color.fromARGB(255, 0, 120, 74),
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        title: Text('Makan Siang'),
                        trailing: Text(
                          '500',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: lunch.length,
                  itemBuilder: (context, index) {
                    final item = lunch[index];

                    return Container(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(item.namalunch),
                                  subtitle: Text('${item.quantity} gr'),
                                  trailing: Text(item.calories),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: IconButton(
                          onPressed: () async {
                            await showDialog<void>(
                                context: context,
                                builder: (context) =>
                                    InputLunch(user: _currentUser));
                          },
                          icon: Icon(Icons.add),
                        ),
                        title: Text(
                          'Tambah Makanan',
                        ),
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5.0,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ],
            )),
            SizedBox(height: 8),
            Container(
                child: Column(
              children: <Widget>[
                Container(
                  color: Color.fromARGB(255, 0, 120, 74),
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        title: Text('Makan Malam'),
                        trailing: Text(
                          '500',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: dinner.length,
                  itemBuilder: (context, index) {
                    final item = dinner[index];

                    return Container(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(item.namadinner),
                                  subtitle: Text('${item.quantity} gr'),
                                  trailing: Text(item.calories),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: IconButton(
                          onPressed: () async {
                            await showDialog<void>(
                                context: context,
                                builder: (context) =>
                                    InputDinner(user: _currentUser));
                          },
                          icon: Icon(Icons.add),
                        ),
                        title: Text(
                          'Tambah Makanan',
                        ),
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5.0,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ],
            )),
            SizedBox(height: 8),
            Container(
                child: Column(
              children: <Widget>[
                Container(
                  color: Color.fromARGB(255, 0, 120, 74),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('Cemilan'),
                        trailing: Text(
                          sum(snack).toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: snack.length,
                  itemBuilder: (context, index) {
                    final item = snack[index];

                    return Container(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(item.namasnack),
                                  subtitle: Text('${item.quantity} gr'),
                                  trailing: Text(item.calories),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: IconButton(
                          onPressed: () async {
                            await showDialog<void>(
                                context: context,
                                builder: (context) =>
                                    InputSnack(user: _currentUser));
                          },
                          icon: Icon(Icons.add),
                        ),
                        title: Text(
                          'Tambah Makanan',
                        ),
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5.0,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoWidget(String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildIconWidget(IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32),
      ],
    );
  }

  Widget _buildLabelWidget(String label) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _showDatePicker() {
    return SingleChildScrollView(
      child: Container(
        width: 250,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              key: Key("left_arrow_button"),
              icon: Icon(Icons.arrow_left, size: 25.0),
              color: _leftArrowColor,
              onPressed: () {
                setState(() {
                  _value = _value.subtract(Duration(days: 1));
                  _rightArrowColor = Color(0xffC1C1C1);
                });
              },
            ),
            TextButton(
              // textColor: Colors.white,
              onPressed: () => _selectDate(),
              // },
              child: Text(_dateFormatter(_value),
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            IconButton(
                key: Key("right_arrow_button"),
                icon: Icon(Icons.arrow_right, size: 25.0),
                color: _rightArrowColor,
                onPressed: () {
                  if (today.difference(_value).compareTo(Duration(days: 1)) ==
                      -1) {
                    setState(() {
                      _rightArrowColor = Color(0xffC1C1C1);
                    });
                  } else {
                    setState(() {
                      _value = _value.add(Duration(days: 1));
                    });
                    if (today.difference(_value).compareTo(Duration(days: 1)) ==
                        -1) {
                      setState(() {
                        _rightArrowColor = Color(0xffC1C1C1);
                      });
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  String _dateFormatter(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    String month;

    switch (tm.month) {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "Jun";
        break;
      case 7:
        month = "Jul";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sep";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
      default:
        month = "Undefined";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Yesterday";
    } else {
      return "${tm.day} $month ${tm.year}";
    }
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _value,
      firstDate: new DateTime(2023),
      lastDate: new DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff5FA55A), //Head background
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _value = picked);
    _stateSetter();
  }

  void _stateSetter() {
    if (today.difference(_value).compareTo(Duration(days: 1)) == -1) {
      setState(() => _rightArrowColor = Color(0xffC1C1C1));
    } else
      setState(() => _rightArrowColor = Color(0xffC1C1C1));
  }

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
