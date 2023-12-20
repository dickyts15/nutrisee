class BreakfastModel {
  final String id;
  final String namabreakfast;
  final String quantity;
  final String calories;
  final String carbs;
  final String fat;
  final String protein;
  final String date;
  final String uid;

  BreakfastModel(
      {required this.id,
      required this.namabreakfast,
      required this.quantity,
      required this.calories,
      required this.carbs,
      required this.fat,
      required this.protein,
      required this.date,
      required this.uid});

  factory BreakfastModel.fromJson(Map<String, dynamic> data) {
    return BreakfastModel(
        id: data['_id'],
        namabreakfast: data['namabreakfast'],
        quantity: data['quantity'],
        calories: data['calories'],
        carbs: data['carbs'],
        fat: data['fat'],
        protein: data['protein'],
        date: data['date'],
        uid: data['uid']);
  }
}
