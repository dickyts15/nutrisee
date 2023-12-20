class LunchModel {
  final String id;
  final String namalunch;
  final String date;
  final String calories;
  final String carbs;
  final String protein;
  final String fat;
  final String quantity;
  final String uid;

  LunchModel(
      {required this.id,
      required this.namalunch,
      required this.date,
      required this.calories,
      required this.carbs,
      required this.protein,
      required this.fat,
      required this.quantity,
      required this.uid});

  factory LunchModel.fromJson(Map<String, dynamic> data) {
    return LunchModel(
        id: data['_id'],
        namalunch: data['namalunch'],
        date: data['date'],
        calories: data['calories'],
        carbs: data['carbs'],
        protein: data['protein'],
        fat: data['fat'],
        quantity: data['quantity'],
        uid: data['uid']);
  }
}
