import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/add_recipe_pages/ingredients.dart';
import 'package:recipe_book/add_recipe_pages/instructions.dart';
import 'package:recipe_book/add_recipe_pages/recipe_basics.dart';
import 'package:recipe_book/keys.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:recipe_book/stepper.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({Key? key}) : super(key: key);

  @override
  AddRecipeState createState() => AddRecipeState();
}

class AddRecipeState extends State<AddRecipe> {
  int _curStep = 0;

  static List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  Keys ke = const Keys();

// ===============================RECIPE BASICS===========================
  static var isMealchosen = false;
  static String mealType = "";
  static String imageName = "";
  static TextEditingController recipeNameController = TextEditingController();
  static TextEditingController recipeDescController = TextEditingController();
  static TextEditingController timeController = TextEditingController();
  static TextEditingController servingsController = TextEditingController();
  // ===============================INGREDIENTS===========================
  static var image;

  static List<String> ingredientsList = <String>[];

  // ===============================INSTRUCTIONS===========================
  static List<String> instructionsList = <String>[];

  static const stepIcons = [
    Ionicons.nutrition_outline,
    Ionicons.pizza_outline,
    Ionicons.wine_outline
  ];
  final List<String> titles = ["Basics", "Ingredients", "Instructions"];
  static const placeholderUrl =
      "https://firebasestorage.googleapis.com/v0/b/recipe-book-b2e16.appspot.com/o/placeholder.png?alt=media&token=dfefa5e7-be8f-4fda-9bcf-f6a87501681a";

  resetFields() {
    setState(() {
      isMealchosen = false;
      image = "";
      imageName = "";
      ingredientsList = [];
      instructionsList = [];
      recipeNameController.text = "";
      timeController.text = "";
      recipeDescController.text = "";
      servingsController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.center,
            child: Text("Create Recipe",
                style: GoogleFonts.sofia(
                  textStyle: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                )),
          ),
          backgroundColor: const Color(0xFFFA8072),
          elevation: 1,
          iconTheme: const IconThemeData(color: Color(0xFFFA8072)),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          StepProgressView(
            icons: stepIcons,
            width: MediaQuery.of(context).size.width,
            curStep: _curStep,
            color: const Color(0xFFFA8072),
            titles: titles,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: forms(_curStep),
          ),
          Container(
            height: 60,
            margin: const EdgeInsets.all(15),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_curStep < stepIcons.length - 1) {
                        if (formKeys[_curStep].currentState!.validate()) {
                          setState(() {
                            _curStep += 1;
                          });
                        }
                      }
                      final isValid = formKeys[2].currentState?.validate();
                      if (isValid != null &&
                          formKeys[2].currentState!.validate()) {
                        AddRecipeState.image ??= placeholderUrl;

                        addRecipe(
                            mealType,
                            recipeNameController.text,
                            recipeDescController.text,
                            timeController.text,
                            servingsController.text,
                            AddRecipeState.image,
                            ingredientsList,
                            instructionsList,
                            false,
                            context,
                            resetFields());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFA8072),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                        _curStep == stepIcons.length - 1
                            ? 'Submit'
                            : "Continue",
                        style: const TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_curStep == 0) {
                          return;
                        }
                        _curStep -= 1;
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFA8072),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(
                            color: Colors.white,
                          ))),
                ),
              ],
            ),
          ),
        ])));
  }
}

Widget forms(curStep) {
  switch (curStep) {
    case 0:
      return const Basics();

    case 1:
      return const Ingredients();

    case 2:
      return const Instructions();
  }
  return const Basics();
}

addRecipe(mealtype, name, description, duration, servings, image, ingredients,
    instructions, favourite, context, reset) async {
  Map<String, dynamic> data = <String, dynamic>{
    "mealtype": mealtype,
    "name": name,
    "description": description,
    "duration": duration,
    "servings": servings,
    "image": image,
    "ingredients": ingredients,
    "instructions": instructions,
    "favourite": favourite,
  };

  await FirebaseFirestore.instance
      .collection('recipes')
      .doc()
      .set(data)
      .whenComplete(() => {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recipe successfully added.')),
            ),
            reset
          })
      .catchError((e) => print('error $e'));
}
