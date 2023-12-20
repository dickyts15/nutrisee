class LatihanModel {
  final String id;
  final String namalatihan;
  final String calories;
  final String date;
  final String uid;

  LatihanModel(
      {required this.id,
      required this.namalatihan,
      required this.calories,
      required this.date,
      required this.uid});

  factory LatihanModel.fromJson(Map<String, dynamic> data) {
    return LatihanModel(
        id: data['_id'],
        namalatihan: data['namalatihan'],
        calories: data['calories'],
        date: data['date'],
        uid: data['uid']);
  }
}
