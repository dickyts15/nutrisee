import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/pages/bmi_calculator_input_page.dart';
import 'package:nutrisee/pages/tdee_calculator_input_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const HomePage(),
    // const BukuHarian(),
    // const Progress(),
    // const ProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: BoxDecoration(color: Color.fromARGB(255, 0, 120, 74)),
              accountName: Text('Dicky Tegar', style: GoogleFonts.rubik()),
              accountEmail: Text('dicky.tegar@mhs.itenas.ac.id',
                  style: GoogleFonts.rubik()),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(250, 250, 250, 250),
                child: Icon(Icons.person),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.menu_book),
              title: Text('Buku Harian', style: GoogleFonts.rubik()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.content_paste_search_outlined),
              title: Text('BMI Calculator', style: GoogleFonts.rubik()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BMICalculatorInputPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.run_circle_outlined),
              title: Text('TDEE Calculator', style: GoogleFonts.rubik()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TDEECalculatorInputPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.food_bank_sharp),
              title:
                  Text('Macronutrients Calculator', style: GoogleFonts.rubik()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile Page', style: GoogleFonts.rubik()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 8.0),
            Center(
              child: Text(
                'Hello, User!',
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
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: Color.fromARGB(255, 250, 250, 250)),
                        ),
                        Text('Sisa = Sasaran - Makanan + Latihan',
                            style: GoogleFonts.crimsonPro(
                              color: Color.fromARGB(255, 250, 250, 250),
                              fontSize: 16.0,
                            )),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color.fromARGB(255, 250, 250, 250),
                                    width: 4.0,
                                  )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '3,178',
                                    style: GoogleFonts.rubik(
                                        color:
                                            Color.fromARGB(255, 250, 250, 250),
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Tersisa',
                                    style: GoogleFonts.rubik(
                                        color:
                                            Color.fromARGB(255, 250, 250, 250),
                                        fontSize: 12.0),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: 64.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.flag_rounded,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 24.0),
                                    Icon(Icons.fastfood,
                                        color: Colors.lightBlue),
                                    SizedBox(height: 24.0),
                                    Icon(
                                      Icons.directions_run_sharp,
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 8.0),
                                Column(
                                  children: [
                                    Text(
                                      'Sasaran Kalori',
                                      style: GoogleFonts.rubik(
                                        color:
                                            Color.fromARGB(255, 250, 250, 250),
                                      ),
                                    ),
                                    Text(
                                      '3,178',
                                      style: GoogleFonts.crimsonPro(
                                        color:
                                            Color.fromARGB(255, 250, 250, 250),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      'Makanan',
                                      style: GoogleFonts.rubik(
                                        color:
                                            Color.fromARGB(255, 250, 250, 250),
                                      ),
                                    ),
                                    Text(
                                      '0',
                                      style: GoogleFonts.crimsonPro(
                                        color:
                                            Color.fromARGB(255, 250, 250, 250),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      'Latihan',
                                      style: GoogleFonts.rubik(
                                        color:
                                            Color.fromARGB(255, 250, 250, 250),
                                      ),
                                    ),
                                    Text(
                                      '0',
                                      style: GoogleFonts.crimsonPro(
                                        color:
                                            Color.fromARGB(255, 250, 250, 250),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
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
                  ElevatedButton(onPressed: () {}, child: Text('Edit Target')),
                  SizedBox(height: 8),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Color.fromARGB(255, 0, 120, 74),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.directions_run_sharp,
                                size: 32.0, color: Colors.orange),
                            Text(
                              'Latihan',
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Color.fromARGB(255, 250, 250, 250),
                              ),
                            ),
                            Text(
                              '0',
                              style: GoogleFonts.crimsonPro(
                                color: Color.fromARGB(255, 250, 250, 250),
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Tambahkan Latihan'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Color.fromARGB(255, 0, 120, 74),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.fastfood,
                                size: 32.0, color: Colors.lightBlue),
                            Text(
                              'Makanan',
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Color.fromARGB(255, 250, 250, 250),
                              ),
                            ),
                            Text(
                              '0',
                              style: GoogleFonts.crimsonPro(
                                color: Color.fromARGB(255, 250, 250, 250),
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Tambahkan Makanan'),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
        selectedIconTheme: const IconThemeData(color: Colors.black),
        unselectedLabelStyle: TextStyle(color: Colors.grey[400]),
        selectedLabelStyle: const TextStyle(color: Colors.black),
        fixedColor: Colors.black54,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            tooltip: 'Home',
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            tooltip: 'Buku Harian',
            icon: Icon(Icons.library_books_outlined),
            label: "Buku Harian",
          ),
          BottomNavigationBarItem(
            tooltip: 'Progress',
            icon: Icon(Icons.bar_chart),
            label: "Progress",
          ),
          BottomNavigationBarItem(
            tooltip: 'Akun',
            icon: Icon(Icons.account_box_rounded),
            label: "Akun",
          ),
        ],
      ),
    );
  }
}
