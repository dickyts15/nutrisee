import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/component/models/user_model.dart';
import 'package:nutrisee/pages/buku_harian_page_1.dart';
import 'package:nutrisee/pages/login_page.dart';
import 'package:nutrisee/utils/config.dart';
import 'package:nutrisee/utils/restapi.dart';

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

  late ValueNotifier<int> _notifier;

  List<UserModel> user = [];

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
        title: Text('Buku Harian'),
        foregroundColor: Color.fromARGB(255, 250, 250, 250),
        backgroundColor: Color.fromARGB(255, 0, 120, 74),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(
                child: Text('KALORI',
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w500,
                      fontSize: 24.0,
                    )),
              ),
              Tab(
                child: Text('MAKRO',
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w500,
                      fontSize: 24.0,
                    )),
              ),
            ],
            labelColor: Color.fromARGB(255, 0, 106, 194),
            unselectedLabelColor: Color.fromARGB(255, 21, 21, 21),
            indicatorColor: Color.fromARGB(255, 0, 106, 194),
          ),
          body: TabBarView(
            children: [
              Container(
                child: Center(
                    child: BukuHarian1(
                        user: _currentUser,
                        loggedEmail: _currentUser.email.toString())),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('Tab 2 Content')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
