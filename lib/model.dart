import 'dart:convert';

Recipe recipeFromJson(String str) => Recipe.fromJson(json.decode(str));

String recipeToJson(Recipe data) => json.encode(data.toJson());

class Recipe {
  String? id;
  String name;
  String image;
  String description;
  String servings;
  String mealtype;
  String duration;
  List<String> ingredients;
  List<String> instructions;
  bool favourite;

  Recipe({
    required this.name,
    this.image = "",
    this.id,
    required this.description,
    required this.servings,
    required this.mealtype,
    required this.duration,
    required this.ingredients,
    required this.instructions,
    required this.favourite,
  });

  static Recipe fromJson(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        servings: json["servings"],
        mealtype: json["mealtype"],
        duration: json["duration"],
        ingredients: List<String>.from(json["ingredients"].map((x) => x)),
        instructions: List<String>.from(json["instructions"].map((x) => x)),
        favourite: json["favourite"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "description": description,
        "servings": servings,
        "mealtype": mealtype,
        "duration": duration,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x)),
        "instructions": List<dynamic>.from(instructions.map((x) => x)),
        "favourite": favourite,
      };
}
