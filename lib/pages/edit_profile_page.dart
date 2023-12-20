import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisee/utils/validator.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _editFormKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _genderTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusUsername = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusAge = FocusNode();
  final _focusGender = FocusNode();

  bool _isProcessing = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 120, 74),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
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
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: const AssetImage('profile.jpg'),
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
                      'Dicky Tegar',
                      style: GoogleFonts.rubik(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 51, 51, 51)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _editFormKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _nameTextController,
                                focusNode: _focusName,
                                validator: (value) => Validator.validateName(
                                  name: value,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Nama Lengkap",
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: _emailTextController,
                                focusNode: _focusEmail,
                                validator: (value) => Validator.validateEmail(
                                  email: value,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: _passwordTextController,
                                focusNode: _focusPassword,
                                obscureText: _obscureText,
                                validator: (value) =>
                                    Validator.validatePassword(
                                  password: value,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: _ageTextController,
                                focusNode: _focusAge,
                                validator: (value) => Validator.validateAge(
                                  age: value,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Usia",
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: _genderTextController,
                                focusNode: _focusGender,
                                validator: (value) => Validator.validateGender(
                                  gender: value,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Jenis Kelamin",
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {},
                                    child: Text(
                                      'CANCEL',
                                      style: GoogleFonts.rubik(
                                          fontSize: 15,
                                          letterSpacing: 2,
                                          color: Colors.black),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      shadowColor: Colors.grey,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text(
                                      'SAVE',
                                      style: GoogleFonts.rubik(
                                          fontSize: 15,
                                          letterSpacing: 2,
                                          color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
