class DinnerModel {
  final String id;
  final String namadinner;
  final String quantity;
  final String calories;
  final String carbs;
  final String fat;
  final String protein;
  final String date;
  final String uid;

  DinnerModel(
      {required this.id,
      required this.namadinner,
      required this.quantity,
      required this.calories,
      required this.carbs,
      required this.fat,
      required this.protein,
      required this.date,
      required this.uid});

  factory DinnerModel.fromJson(Map<String, dynamic> data) {
    return DinnerModel(
        id: data['_id'],
        namadinner: data['namadinner'],
        quantity: data['quantity'],
        calories: data['calories'],
        carbs: data['carbs'],
        fat: data['fat'],
        protein: data['protein'],
        date: data['date'],
        uid: data['uid']);
  }
}
