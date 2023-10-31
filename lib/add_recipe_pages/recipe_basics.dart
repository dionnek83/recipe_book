import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:recipe_book/keys.dart';

import '../pages/addrecipe.dart';

class Basics extends StatefulWidget {
  const Basics({Key? key}) : super(key: key);

  @override
  BasicsState createState() => BasicsState();
}

class BasicsState extends State<Basics> {
  final TextEditingController _recipeDescController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();

  Keys ke = Keys();

  var type;
  var name;
  var desc;
  var time;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: AddRecipeState.formKeys[0],
        child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(children: [
              DropdownSearch<String>(
                validator: (v) => v == "Meal Type" ? "*required field" : null,
                dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFFA8072)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFFFA8072), width: 2),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                )),
                items: const ["Breakfast", "Lunch", "Dinner"],
                selectedItem: AddRecipeState.isMealchosen
                    ? AddRecipeState.mealType
                    : "Meal Type",
                onChanged: (selectedItem) {
                  setState(() {
                    AddRecipeState.mealType = selectedItem!;

                    AddRecipeState.isMealchosen = true;
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: AddRecipeState.recipeNameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("*required field");
                  }

                  return null;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFFA8072)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: 'Name',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: AddRecipeState.recipeDescController,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("*required field");
                  }

                  return null;
                },
                onSaved: (value) {
                  _recipeDescController.text = value!;
                },
                onChanged: (String value) {
                  setState(() {
                    desc = value;
                  });
                },
                textInputAction: TextInputAction.next,
                maxLines: 2,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFFA8072)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: AddRecipeState.timeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("*required field");
                  }

                  return null;
                },
                onSaved: (value) {
                  _timeController.text = value!;
                },
                onChanged: (String value) {
                  setState(() {
                    time = value;
                  });
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFFA8072)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: 'Minutes',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: AddRecipeState.servingsController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("*required field");
                  }

                  return null;
                },
                onSaved: (value) {
                  _servingsController.text = value!;
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFFA8072)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: 'Servings',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ])));
  }
}
