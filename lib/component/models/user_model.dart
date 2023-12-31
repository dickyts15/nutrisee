class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;
  final String gender;
  final String age;
  final String namauser;
  final String weightgoal;
  final String weight;
  final String height;
  final String caloriestarget;
  final String profpic;
  final String uid;
  final String tanggallahir;
  final String activity;

  UserModel(
      {required this.id,
      required this.username,
      required this.email,
      required this.password,
      required this.gender,
      required this.age,
      required this.namauser,
      required this.weightgoal,
      required this.weight,
      required this.height,
      required this.caloriestarget,
      required this.profpic,
      required this.uid,
      required this.tanggallahir,
      required this.activity});

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
        id: data['_id'],
        username: data['username'],
        email: data['email'],
        password: data['password'],
        gender: data['gender'],
        age: data['age'],
        namauser: data['namauser'],
        weightgoal: data['weightgoal'],
        weight: data['weight'],
        height: data['height'],
        caloriestarget: data['caloriestarget'],
        profpic: data['profpic'],
        uid: data['uid'],
        tanggallahir: data['tanggallahir'],
        activity: data['activity']);
  }
}
