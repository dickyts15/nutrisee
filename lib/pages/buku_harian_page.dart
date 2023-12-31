import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrisee/component/models/breakfast_model.dart';
import 'package:nutrisee/component/models/dinner_model.dart';
import 'package:nutrisee/component/models/latihan_model.dart';
import 'package:nutrisee/component/models/lunch_model.dart';
import 'package:nutrisee/component/models/snack_model.dart';
import 'package:nutrisee/component/models/user_model.dart';
import 'package:nutrisee/pages/login_page.dart';
import 'package:nutrisee/services/input_breakfast.dart';
import 'package:nutrisee/services/input_dinner.dart';
import 'package:nutrisee/services/input_latihan.dart';
import 'package:nutrisee/services/input_lunch.dart';
import 'package:nutrisee/services/input_snack.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/restapi.dart';
import 'package:pie_chart/pie_chart.dart';

class BukuHarianPage extends StatefulWidget {
  final User user;
  final String loggedEmail;
  const BukuHarianPage(
      {Key? key, required this.user, required this.loggedEmail})
      : super(key: key);

  @override
  State<BukuHarianPage> createState() => _BukuHarianPageState();
}

class _BukuHarianPageState extends State<BukuHarianPage> {
  DataService ds = DataService();
  late User _currentUser;
  bool currentDateStatus = false;

  List<UserModel> user = [];

  late ValueNotifier<int> _notifier;

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
      currentDate = date;
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
      currentDate = date;
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
      currentDate = date;
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
      currentDate = date;
    });
  }

  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();
  Color _rightArrowColor = Colors.grey;
  Color _leftArrowColor = Colors.grey;

  double sumCarbsMakanan = 0;
  double sumProteinsMakanan = 0;
  double sumFatsMakanan = 0;

  Map<String, double> dataMap = {
    "Carbs : 0 gr": 0,
    "Fats : 0 gr": 0,
    "Protein : 0 gr": 0,
  };
  @override
  void initState() {
    _currentUser = widget.user;
    _initializeData();
    super.initState();
    _value = _value;
  }

  void _initializeData() async {
    await selectAllData();
    filterDataLatihan(_dateFormatter(_value));
    filterDataBreakfast(_dateFormatter(_value));
    filterDataLunch(_dateFormatter(_value));
    filterDataDinner(_dateFormatter(_value));
    filterDataSnack(_dateFormatter(_value));
    _notifier = ValueNotifier<int>(0);

    sumCarbsMakanan = sumCarbMakanan().toDouble();
    sumProteinsMakanan = sumProteinMakanan().toDouble();
    sumFatsMakanan = sumFatMakanan().toDouble();
    dataMap = {
      "Carbs : $sumCarbsMakanan gr": sumCarbsMakanan,
      "Fats : $sumFatsMakanan gr": sumFatsMakanan,
      "Protein : $sumProteinsMakanan gr": sumProteinsMakanan,
    };
  }

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
                      title: Text('Buku Harian'),
                      foregroundColor: Color.fromARGB(255, 250, 250, 250),
                      backgroundColor: Color.fromARGB(255, 0, 120, 74),
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _showDatePicker(),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Sasaran Kalori',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _buildInfoWidget('${user[0].caloriestarget}'),
                                _buildIconWidget(Icons.remove),
                                _buildInfoWidget(sumMakanan().toString()),
                                _buildIconWidget(Icons.add),
                                _buildInfoWidget(
                                    sum(latihanCurrDate).toString()),
                                _buildInfoWidget('='),
                                _buildInfoWidget(
                                    (int.parse(user[0].caloriestarget) -
                                            sumMakanan() +
                                            sum(latihanCurrDate))
                                        .toString()),
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
                              child: PieChart(
                                dataMap: dataMap,
                                chartType: ChartType.disc,
                                chartRadius: 125,
                                legendOptions: LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                  showLegends: true,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValueBackground: false,
                                  showChartValues: true,
                                  showChartValuesInPercentage: true,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 1,
                                ),
                              ),
                            ),
                            Container(
                              height: 5.0,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 2.0),
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
                                        ListTile(
                                          title: Text('Sarapan'),
                                          trailing: Text(
                                            '${sum(breakfastCurrDate).toString()} kcal',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          textColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: breakfastCurrDate.length,
                                    itemBuilder: (context, index) {
                                      final item = breakfastCurrDate[index];

                                      return Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              child: Column(
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(
                                                        item.namabreakfast),
                                                    subtitle: Row(children: [
                                                      Icon(
                                                        Icons.circle,
                                                        color: Colors.redAccent,
                                                        size: 15,
                                                      ),
                                                      Text('${item.carbs} gr '),
                                                      SizedBox(width: 8),
                                                      Icon(
                                                        Icons.circle,
                                                        color:
                                                            Colors.blueAccent,
                                                        size: 15,
                                                      ),
                                                      Text('${item.fat} gr '),
                                                      SizedBox(width: 8),
                                                      Icon(
                                                        Icons.circle,
                                                        color:
                                                            Colors.greenAccent,
                                                        size: 15,
                                                      ),
                                                      Text(
                                                          '${item.protein} gr '),
                                                    ]),
                                                    leading: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                            '${item.quantity} gr'),
                                                        Text(
                                                            '${item.calories} kcal'),
                                                      ],
                                                    ),
                                                    trailing: IconButton(
                                                      icon: Icon(Icons.delete,
                                                          color: Colors.red),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  "warning"),
                                                              content: const Text(
                                                                  "Remove this data?"),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child: const Text(
                                                                      "CANCEL"),
                                                                  onPressed:
                                                                      () {
                                                                    //Close Dialog
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child: const Text(
                                                                      "REMOVE"),
                                                                  onPressed:
                                                                      () async {
                                                                    //close Dialog
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();

                                                                    bool response = await ds.removeId(
                                                                        token,
                                                                        project,
                                                                        'breakfast',
                                                                        appid,
                                                                        item.id);

                                                                    if (response) {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              BukuHarianPage(
                                                                            user:
                                                                                _currentUser,
                                                                            loggedEmail:
                                                                                _currentUser.email.toString(),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
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
                                                      InputBreakfast(
                                                          user: _currentUser,
                                                          currDate:
                                                              currentDate));
                                            },
                                            icon: Icon(Icons.add),
                                          ),
                                          title: Text(
                                            'Tambah Breakfast',
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
                                        top: BorderSide(
                                            color: Colors.grey, width: 2.0),
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
                                      ListTile(
                                        title: Text('Makan Siang'),
                                        trailing: Text(
                                          '${sum(lunchCurrDate).toString()} kcal',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        textColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: lunchCurrDate.length,
                                  itemBuilder: (context, index) {
                                    final item = lunchCurrDate[index];

                                    return Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(item.namalunch),
                                                  subtitle: Text(
                                                      '${item.quantity} gr'),
                                                  leading: Text(
                                                      '${item.calories} kcal'),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "warning"),
                                                            content: const Text(
                                                                "Remove this data?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text(
                                                                    "CANCEL"),
                                                                onPressed: () {
                                                                  //Close Dialog
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: const Text(
                                                                    "REMOVE"),
                                                                onPressed:
                                                                    () async {
                                                                  //close Dialog
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();

                                                                  bool
                                                                      response =
                                                                      await ds.removeId(
                                                                          token,
                                                                          project,
                                                                          'lunch',
                                                                          appid,
                                                                          item.id);

                                                                  if (response) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                BukuHarianPage(
                                                                          user:
                                                                              _currentUser,
                                                                          loggedEmail: _currentUser
                                                                              .email
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
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
                                                    InputLunch(
                                                        user: _currentUser,
                                                        currDate: currentDate));
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                        title: Text(
                                          'Tambah Lunch',
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
                                      top: BorderSide(
                                          color: Colors.grey, width: 2.0),
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
                                        title: Text('Makan Malam'),
                                        trailing: Text(
                                          '${sum(dinnerCurrDate).toString()} kcal',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        textColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: dinnerCurrDate.length,
                                  itemBuilder: (context, index) {
                                    final item = dinnerCurrDate[index];

                                    return Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(item.namadinner),
                                                  subtitle: Text(
                                                      '${item.quantity} gr'),
                                                  leading: Text(
                                                      '${item.calories} kcal'),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "warning"),
                                                            content: const Text(
                                                                "Remove this data?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text(
                                                                    "CANCEL"),
                                                                onPressed: () {
                                                                  //Close Dialog
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: const Text(
                                                                    "REMOVE"),
                                                                onPressed:
                                                                    () async {
                                                                  //close Dialog
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();

                                                                  bool
                                                                      response =
                                                                      await ds.removeId(
                                                                          token,
                                                                          project,
                                                                          'dinner',
                                                                          appid,
                                                                          item.id);

                                                                  if (response) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                BukuHarianPage(
                                                                          user:
                                                                              _currentUser,
                                                                          loggedEmail: _currentUser
                                                                              .email
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
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
                                                    InputDinner(
                                                        user: _currentUser,
                                                        currDate: currentDate));
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                        title: Text(
                                          'Tambah Dinner',
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
                                      top: BorderSide(
                                          color: Colors.grey, width: 2.0),
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
                                          '${sum(snackCurrDate).toString()} kcal',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        textColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snackCurrDate.length,
                                  itemBuilder: (context, index) {
                                    final item = snackCurrDate[index];

                                    return Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(item.namasnack),
                                                  subtitle: Text(
                                                      '${item.quantity} gr'),
                                                  leading: Text(
                                                      '${item.calories} kcal'),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "warning"),
                                                            content: const Text(
                                                                "Remove this data?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text(
                                                                    "CANCEL"),
                                                                onPressed: () {
                                                                  //Close Dialog
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: const Text(
                                                                    "REMOVE"),
                                                                onPressed:
                                                                    () async {
                                                                  //close Dialog
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();

                                                                  bool
                                                                      response =
                                                                      await ds.removeId(
                                                                          token,
                                                                          project,
                                                                          'snack',
                                                                          appid,
                                                                          item.id);

                                                                  if (response) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                BukuHarianPage(
                                                                          user:
                                                                              _currentUser,
                                                                          loggedEmail: _currentUser
                                                                              .email
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
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
                                                    InputSnack(
                                                        user: _currentUser,
                                                        currDate: currentDate));
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                        title: Text(
                                          'Tambah Snack',
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
                                      top: BorderSide(
                                          color: Colors.grey, width: 2.0),
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
                                        title: Text('Latihan'),
                                        trailing: Text(
                                          '${sum(latihanCurrDate).toString()} kcal',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        textColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: latihanCurrDate.length,
                                  itemBuilder: (context, index) {
                                    final item = latihanCurrDate[index];

                                    return Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(item.namalatihan),
                                                  leading: Text(item.calories),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "warning"),
                                                            content: const Text(
                                                                "Remove this data?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text(
                                                                    "CANCEL"),
                                                                onPressed: () {
                                                                  //Close Dialog
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: const Text(
                                                                    "REMOVE"),
                                                                onPressed:
                                                                    () async {
                                                                  //close Dialog
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();

                                                                  bool
                                                                      response =
                                                                      await ds.removeId(
                                                                          token,
                                                                          project,
                                                                          'latihan',
                                                                          appid,
                                                                          item.id);

                                                                  if (response) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                BukuHarianPage(
                                                                          user:
                                                                              _currentUser,
                                                                          loggedEmail: _currentUser
                                                                              .email
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
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
                                                    InputLatihan(
                                                        user: _currentUser,
                                                        currDate: currentDate
                                                            .toString()));
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                        title: Text(
                                          'Tambah Latihan',
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
                                      top: BorderSide(
                                          color: Colors.grey, width: 2.0),
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
                                SizedBox(height: 24.0),
                                // Container(
                                //   child: Text('Ini Bagian Makro'),
                                // ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
          }
        },
      );

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
                setStateValueSubs();
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
                    setStateValueAdd();

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

  void setStateValueSubs() {
    setState(() {
      _value = _value.subtract(Duration(days: 1));
      _rightArrowColor = Color(0xffC1C1C1);
      filterDataLatihan(_dateFormatter(_value));
      filterDataBreakfast(_dateFormatter(_value));
      filterDataLunch(_dateFormatter(_value));
      filterDataDinner(_dateFormatter(_value));
      filterDataSnack(_dateFormatter(_value));
      sumCarbsMakanan = sumCarbMakanan().toDouble();
      sumProteinsMakanan = sumProteinMakanan().toDouble();
      sumFatsMakanan = sumFatMakanan().toDouble();
      dataMap = {
        "Carbs : $sumCarbsMakanan gr": sumCarbsMakanan,
        "Fats : $sumFatsMakanan gr": sumFatsMakanan,
        "Protein : $sumProteinsMakanan gr": sumProteinsMakanan,
      };
    });
  }

  void setStateValueAdd() {
    setState(() {
      _value = _value.add(Duration(days: 1));
      filterDataLatihan(_dateFormatter(_value));
      filterDataBreakfast(_dateFormatter(_value));
      filterDataLunch(_dateFormatter(_value));
      filterDataDinner(_dateFormatter(_value));
      filterDataSnack(_dateFormatter(_value));
      sumCarbsMakanan = sumCarbMakanan().toDouble();
      sumProteinsMakanan = sumProteinMakanan().toDouble();
      sumFatsMakanan = sumFatMakanan().toDouble();
      dataMap = {
        "Carbs : $sumCarbsMakanan gr": sumCarbsMakanan,
        "Fats : $sumFatsMakanan gr": sumFatsMakanan,
        "Protein : $sumProteinsMakanan gr": sumProteinsMakanan,
      };
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

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _value,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff5FA55A), //Head background
          ),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        _value = picked;
        filterDataLatihan(_dateFormatter(_value));
        filterDataBreakfast(_dateFormatter(_value));
        filterDataLunch(_dateFormatter(_value));
        filterDataDinner(_dateFormatter(_value));
        filterDataSnack(_dateFormatter(_value));
        sumCarbsMakanan = sumCarbMakanan().toDouble();
        sumProteinsMakanan = sumProteinMakanan().toDouble();
        sumFatsMakanan = sumFatMakanan().toDouble();
        dataMap = {
          "Carbs : $sumCarbsMakanan gr": sumCarbsMakanan,
          "Fats : $sumFatsMakanan gr": sumFatsMakanan,
          "Protein : $sumProteinsMakanan gr": sumProteinsMakanan,
        };
      });
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
          data is SnackModel ||
          data is LatihanModel) {
        return total + int.parse(data.calories);
      } else {
        return total;
      }
    });
  }

  int sumMakanan() {
    int total = 0;
    total = sum(breakfastCurrDate) +
        sum(lunchCurrDate) +
        sum(dinnerCurrDate) +
        sum(snackCurrDate);
    return total;
  }

  int sumCarb(List<dynamic> data) {
    return data.fold(0, (total, data) {
      if (data is BreakfastModel ||
          data is LunchModel ||
          data is DinnerModel ||
          data is SnackModel) {
        return total + int.parse(data.carbs);
      } else {
        return total;
      }
    });
  }

  int sumCarbMakanan() {
    int total = 0;
    total = sumCarb(breakfastCurrDate) +
        sumCarb(lunchCurrDate) +
        sumCarb(dinnerCurrDate) +
        sumCarb(snackCurrDate);
    return total;
  }

  int sumProtein(List<dynamic> data) {
    return data.fold(0, (total, data) {
      if (data is BreakfastModel ||
          data is LunchModel ||
          data is DinnerModel ||
          data is SnackModel) {
        return total + int.parse(data.protein);
      } else {
        return total;
      }
    });
  }

  int sumProteinMakanan() {
    int total = 0;
    total = sumProtein(breakfastCurrDate) +
        sumProtein(lunchCurrDate) +
        sumProtein(dinnerCurrDate) +
        sumProtein(snackCurrDate);
    return total;
  }

  int sumFats(List<dynamic> data) {
    return data.fold(0, (total, data) {
      if (data is BreakfastModel ||
          data is LunchModel ||
          data is DinnerModel ||
          data is SnackModel) {
        return total + int.parse(data.fat);
      } else {
        return total;
      }
    });
  }

  int sumFatMakanan() {
    int total = 0;
    total = sumFats(breakfastCurrDate) +
        sumFats(lunchCurrDate) +
        sumFats(dinnerCurrDate) +
        sumFats(snackCurrDate);
    return total;
  }
}
