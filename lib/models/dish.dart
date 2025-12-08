// Dish model for the main screen (SelectDishesScreen)
class Dish {
  final int id;
  final String name;
  final double rating;
  final String description;
  final List<String> equipments;
  final String image;

  Dish({
    required this.id,
    required this.name,
    required this.rating,
    required this.description,
    required this.equipments,
    required this.image,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] as int,
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      description: json['description'] as String,
      equipments: List<String>.from(json['equipments']),
      image: json['image'] as String,
    );
  }
}

// PopularDish model for the main screen
class PopularDish {
  final int id;
  final String name;
  final String image;

  PopularDish({
    required this.id,
    required this.name,
    required this.image,
  });

  factory PopularDish.fromJson(Map<String, dynamic> json) {
    return PopularDish(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }
}