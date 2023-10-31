import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_book/keys.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../pages/addrecipe.dart';

class Ingredients extends StatefulWidget {
  const Ingredients({Key? key}) : super(key: key);

  @override
  IngredientsState createState() => IngredientsState();
}

class IngredientsState extends State<Ingredients> {
  final TextEditingController _ingredientController = TextEditingController();
  final List<String> ingredients = <String>[];

//  final _formKey = GlobalKey<FormState>();
  File? image;

  File? _imageFile;
  String imageName = "";

// Allows the user to select an image from the gallery
  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _imageFile = File(image.path);
      AddRecipeState.imageName = image.name;
    });
    // uploadFile();
  }

// Push image to Firebase storage
  uploadFile() async {
    if (_imageFile == null) return;
    try {
      final ref =
          FirebaseStorage.instance.ref().child('recipe').child('/$imageName');

      await ref
          .putFile(_imageFile!)
          .whenComplete(() => ref.getDownloadURL().then((value) => setState(() {
                AddRecipeState.image = value;
              })));
    } catch (e) {
      print(e);
    }
  }

  void _addIngredient(String title) {
    setState(() {
      AddRecipeState.ingredientsList.add(title);
    });
    _ingredientController.clear();
  }

  void _removeIngredient(String title) {
    setState(() {
      AddRecipeState.ingredientsList.remove(title);
    });
  }

  void _editIngredient(String title) {
    setState(() {
      _ingredientController.text = title;
    });
    _removeIngredient(title);
  }

  Widget _buildIngredientItem(String title) {
    return ListTile(title: Text(title));
  }

  List<Widget> _getItems() {
    final List<Widget> ingredientWidgets = <Widget>[];
    for (String title in ingredients) {
      ingredientWidgets.add(_buildIngredientItem(title));
    }
    return ingredientWidgets;
  }

  bool isEditing = false;
  List<Widget> _ingredients() {
    var list = <Widget>[];
    AddRecipeState.ingredientsList.asMap().forEach((i, text) {
      list.add(Card(
          color: const Color(0xFFFA8072),
          child: ListTile(
            title: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      _editIngredient(text);
                    },
                    icon: const Icon(Icons.edit, color: Colors.white)),
                IconButton(
                    onPressed: () {
                      _removeIngredient(text);
                    },
                    icon: const Icon(Icons.delete, color: Colors.white)),
              ],
            ),
          )));
    });
    return list;
  }

  Keys ke = Keys();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: AddRecipeState.formKeys[1],
        child: SizedBox(
            width: double.infinity,
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    pickImage();
                  },
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: const Text("Upload Image"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA8072),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Text(AddRecipeState.imageName != ""
                      ? AddRecipeState.imageName
                      : "Default Image Selected")),
              TextFormField(
                controller: _ingredientController,
                validator: (ingredients) {
                  if (AddRecipeState.ingredientsList.isEmpty) {
                    return "*required field";
                  }

                  return null;
                },
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
                  hintText: 'Add Ingredient',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (AddRecipeState.ingredientsList
                          .contains(_ingredientController.text)) {
                        _editIngredient(_ingredientController.text);
                      } else {
                        if (_ingredientController.text != "") {
                          _addIngredient(_ingredientController.text);
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xFFFA8072),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text("Ingredients",
                    style: GoogleFonts.sofia(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFA8072),
                      ),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                constraints: const BoxConstraints(minHeight: 100),
                child: Column(
                  children: _ingredients(),
                ),
              ),
            ])));
  }
}

// class Ingredient {
//   Ingredient({required this.name, required this.isEditing});
//   final String name;
//   bool isEditing;
// }
