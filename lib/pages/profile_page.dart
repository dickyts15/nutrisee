import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/user_model.dart';
import 'package:nutrisee/pages/login_page.dart';
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

  @override
  Widget build(BuildContext context) {
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
                    return Column(
                      children: [
                        SizedBox(height: 20),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 55),
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
                                      onTap: () {},
                                      child: const CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          0,
                                          120,
                                          74,
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    '${_currentUser.displayName}',
                                    style: GoogleFonts.rubik(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 21, 21, 21)),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                      padding: const EdgeInsets.all(8.0),
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
                                      padding: const EdgeInsets.all(8.0),
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
                        SizedBox(height: 16),
                        Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
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
                                    color:
                                        const Color.fromARGB(255, 21, 21, 21)),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Berat Badan',
                                style: GoogleFonts.rubik(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 21, 21, 21)),
                              ),
                              SizedBox(height: 20),
                              Text(
                                '${user[0].weightgoal} kg',
                                style: GoogleFonts.rubik(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 21, 21, 21)),
                              ),
                              SizedBox(height: 40),
                              Text(
                                'Kalori Harian',
                                style: GoogleFonts.rubik(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 21, 21, 21)),
                              ),
                              SizedBox(height: 20),
                              Text(
                                '${user[0].caloriestarget} kal',
                                style: GoogleFonts.rubik(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 21, 21, 21)),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Edit Sasaran',
                                    style: GoogleFonts.rubik(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(255, 21, 21, 21)),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }
            }
          }),
    );
  }
}
