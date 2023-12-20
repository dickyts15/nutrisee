class SnackModel {
  final String id;
  final String namasnack;
  final String quantity;
  final String calories;
  final String carbs;
  final String fat;
  final String protein;
  final String date;
  final String uid;

  SnackModel(
      {required this.id,
      required this.namasnack,
      required this.quantity,
      required this.calories,
      required this.carbs,
      required this.fat,
      required this.protein,
      required this.date,
      required this.uid});

  factory SnackModel.fromJson(Map<String, dynamic> data) {
    return SnackModel(
        id: data['_id'],
        namasnack: data['namasnack'],
        quantity: data['quantity'],
        calories: data['calories'],
        carbs: data['carbs'],
        fat: data['fat'],
        protein: data['protein'],
        date: data['date'],
        uid: data['uid']);
  }
}
