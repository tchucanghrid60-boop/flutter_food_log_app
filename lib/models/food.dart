class Food {
  String? id;
  DateTime? create_at;
  DateTime? foodDate;
  String? foodMeal;
  String? foodName;
  double? foodPrice;
  int? foodPerson;

  Food({
    this.id,
    this.create_at,
    this.foodDate,
    this.foodMeal,
    this.foodName,
    this.foodPrice,
    this.foodPerson,
  });

  Map<String, dynamic> toMap() => {
        'create_at': create_at,
        'foodDate': foodDate,
        'foodMeal': foodMeal,
        'foodName': foodName,
        'foodPrice': foodPrice,
        'foodPerson': foodPerson,
      };

  factory Food.fromMap(Map<String, dynamic> map) => Food(
        id: map['id'] as String,
        create_at: DateTime.parse(map['create_at']),
        foodDate: DateTime.parse(map['foodDate']),
        foodMeal: map['foodMeal'] as String,
        foodName: map['foodName'] as String,
        foodPrice: double.parse(map['foodPrice']),
        foodPerson: int.parse(map['foodPerson']),
      );
}
