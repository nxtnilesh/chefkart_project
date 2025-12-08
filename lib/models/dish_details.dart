class IngredientItem {
  final String name;
  final String quantity;

  IngredientItem({required this.name, required this.quantity});

  factory IngredientItem.fromJson(Map<String, dynamic> json) {
    return IngredientItem(
      name: json['name'] as String,
      quantity: json['quantity'] as String,
    );
  }
}

class Appliance {
  final String name;
  final String image; 

  Appliance({required this.name, required this.image});

  factory Appliance.fromJson(Map<String, dynamic> json) {
    return Appliance(
      name: json['name'] as String,
      image: json['image'] as String? ?? '', 
    );
  }
}

class DishDetails {
  final String name;
  final int id;
  final String timeToPrepare;
  final List<IngredientItem> vegetables;
  final List<IngredientItem> spices;
  final List<Appliance> appliances;

  DishDetails({
    required this.name,
    required this.id,
    required this.timeToPrepare,
    required this.vegetables,
    required this.spices,
    required this.appliances,
  });

  factory DishDetails.fromJson(Map<String, dynamic> json) {
    final ingredients = json['ingredients'] as Map<String, dynamic>;

    return DishDetails(
      name: json['name'] as String,
      id: json['id'] as int,
      timeToPrepare: json['timeToPrepare'] as String,
      vegetables: (ingredients['vegetables'] as List)
          .map((i) => IngredientItem.fromJson(i))
          .toList(),
      spices: (ingredients['spices'] as List)
          .map((i) => IngredientItem.fromJson(i))
          .toList(),
      appliances: (ingredients['appliances'] as List)
          .map((i) => Appliance.fromJson(i))
          .toList(),
    );
  }
}