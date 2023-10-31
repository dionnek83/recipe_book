import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book/model.dart';
import 'package:recipe_book/pages/loader.dart';
import 'package:image_picker/image_picker.dart';

class UpdateRecipe extends StatefulWidget {
  final Recipe recipe;
  const UpdateRecipe({Key? key, required this.recipe}) : super(key: key);

  @override
  UpdateRecipeState createState() => UpdateRecipeState();
}

class UpdateRecipeState extends State<UpdateRecipe> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

//Change image -----------------------------------------------------------------
  String image = "";
  String image1 = "";

  File? _imageFile;
  String imageName = "";
  bool updateImage = false;

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _imageFile = File(image.path);
      updateImage = true;
    });
  }

  uploadFile() async {
    if (_imageFile == null) return;

    try {
      final ref = FirebaseStorage.instance.ref().child('/$imageName');

      await ref
          .putFile(_imageFile!)
          .whenComplete(() => ref.getDownloadURL().then((value) => setState(() {
                image1 = value;

                // print(value);
              })));
    } catch (e) {
      print(e);
    }
  }

  //Update fields -----------------------------------------------------------------------------
  String? mealtype = "";
  String name = "";
  String description = "";
  String duration = "";
  String servings = "";
  List<String> ingredientsList = <String>[];
  List<String> instructionsList = <String>[];

  updateFields() {
    //data

    if (updateImage == true) {
      uploadFile();
    }

    Map<String, dynamic> data = <String, dynamic>{
      "mealtype": mealtype != "" ? mealtype : widget.recipe.mealtype,
      "name": name != "" ? name : widget.recipe.name,
      "description":
          description != "" ? description : widget.recipe.description,
      "duration": duration != "" ? duration : widget.recipe.duration,
      "servings": servings != "" ? servings : widget.recipe.servings,
      "image": image1 != "" ? image1 : widget.recipe.image,
      "ingredients": widget.recipe.ingredients,
      "instructions": widget.recipe.instructions,
      "favourite": widget.recipe.favourite
    };

    return FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipe.id)
        .update(data)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe successfully updated.'))))
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print("Failed to update recipe: $error"));
  }

  final TextEditingController _ingredientController = TextEditingController();

  void _addIngredient(String title) {
    setState(() {
      widget.recipe.ingredients.add(title);
    });
    _ingredientController.clear();
  }

  void _editIngredient(String title) {
    setState(() {
      _ingredientController.text = title;
    });
    _removeIngredient(title);
  }

  void _removeIngredient(String title) {
    setState(() {
      widget.recipe.ingredients.remove(title);
    });
  }

  List<Widget> _ingredients() {
    var list = <Widget>[];
    widget.recipe.ingredients.asMap().forEach((i, text) {
      list.add(Card(
          color: Colors.grey[100],
          child: ListTile(
            title: Text(
              text,
              style: const TextStyle(color: Colors.black87),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      _editIngredient(text);
                    },
                    icon: const Icon(Icons.edit, color: Color(0xFFFA8072))),
                IconButton(
                    onPressed: () {
                      _removeIngredient(text);
                    },
                    icon: const Icon(Icons.delete, color: Color(0xFFFA8072))),
              ],
            ),
          )));
    });
    return list;
  }

//Instruction ------------------------------------------------------------------
  final TextEditingController _instructionController = TextEditingController();

  void _addInstruction(String title) {
    setState(() {
      widget.recipe.instructions.add(title);
    });
    _instructionController.clear();
  }

  void _editInstruction(String title) {
    setState(() {
      _instructionController.text = title;
    });
    _removeInstruction(title);
  }

  void _removeInstruction(String title) {
    setState(() {
      widget.recipe.instructions.remove(title);
    });
  }

  List<Widget> _instructions() {
    var list = <Widget>[];
    widget.recipe.instructions.asMap().forEach((i, text) {
      list.add(Card(
          color: Colors.grey[100],
          child: ListTile(
            title: Text(
              text,
              style: const TextStyle(color: Colors.black87),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      _editInstruction(text);
                    },
                    icon: const Icon(Icons.edit, color: Color(0xFFFA8072))),
                IconButton(
                    onPressed: () {
                      _removeInstruction(text);
                    },
                    icon: const Icon(Icons.delete, color: Color(0xFFFA8072))),
              ],
            ),
          )));
    });
    return list;
  }

  // bool _isLoading = true;

  // void _showLoadingIndicator() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
                //  padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
                padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                child: Column(children: [
                  Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          updateImage == true
                              ? Image.file(_imageFile!,
                                  width: double.infinity,
                                  height: (size.height / 2) + 50,
                                  fit: BoxFit.cover)

                              // ClipRRect(
                              //     child: Image(
                              //       width: double.infinity,
                              //       height: (size.height / 2) + 50,
                              //       image: NetworkImage(
                              //         image1,
                              //       ),
                              //       fit: BoxFit.cover,
                              //     ),
                              //   )
                              : ClipRRect(
                                  child: Image(
                                    width: double.infinity,
                                    height: (size.height / 2) + 50,
                                    image: NetworkImage(widget.recipe.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),

                          // ClipRRect(

                          //   child: Image(
                          //     width: double.infinity,
                          //     height: (size.height / 2) + 50,
                          //     image: NetworkImage(widget.recipe.image),
                          //     fit: BoxFit.cover,
                          //   ),
                          // )
                        ],
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: IconButton(
                              onPressed: () async {
                                pickImage();
                              },
                              icon: const Icon(FluentIcons.image_20_regular,
                                  size: 25, color: Color(0xFFFA8072))),
                        ),
                      ),
                      Positioned(
                          top: 5,
                          left: 5,
                          child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const CircleAvatar(
                                backgroundColor: Color(0xFFFA8072),
                                radius: 30,
                                child: Icon(CupertinoIcons.back,
                                    color: Colors.black, size: 25),
                              )))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    //  margin: const EdgeInsets.only(left: 25, right: 25),
                    alignment: Alignment.topLeft,
                    child: const Text("Meal Type",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  DropdownSearch<String>(
                    validator: (v) =>
                        v == "Meal Type" ? "*required field" : null,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink)),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFFA8072)),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFFFA8072), width: 2),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    )),
                    items: const ["Breakfast", "Lunch", "Dinner"],
                    selectedItem: widget.recipe.mealtype,
                    onChanged: (selectedItem) {
                      // setState(() {
                      //   AddRecipeState.mealType = selectedItem!;

                      //   AddRecipeState.isMealchosen = true;
                      // });
                      setState(() {
                        mealtype = selectedItem;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text("Name",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      child: TextFormField(
                    controller: nameController,
                    minLines: 1,
                    cursorColor: Colors.black,
                    onChanged: (enteredname) {
                      // setState(() {
                      //   AddRecipeState.mealType = selectedItem!;

                      //   AddRecipeState.isMealchosen = true;
                      // });
                      setState(() {
                        name = enteredname;
                      });
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        fillColor: Colors.grey[100],
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.red)),
                        hintText: widget.recipe.name,
                        hintStyle: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 36, 36, 36)),
                        contentPadding: const EdgeInsets.only(left: 15)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Recipe name is required';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text("Description",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      child: TextFormField(
                    minLines: 3,
                    maxLines: 10,
                    onChanged: (entereddescription) {
                      // setState(() {
                      //   AddRecipeState.mealType = selectedItem!;

                      //   AddRecipeState.isMealchosen = true;
                      // });
                      setState(() {
                        description = entereddescription;
                      });
                    },
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        fillColor: Colors.grey[100],
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.red)),
                        hintText: widget.recipe.description,
                        hintStyle: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 36, 36, 36)),
                        contentPadding: const EdgeInsets.all(15)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Recipe name is required';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text("Duration",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: TextFormField(
                        minLines: 1,
                        onChanged: (enteredduratoin) {
                          // setState(() {
                          //   AddRecipeState.mealType = selectedItem!;

                          //   AddRecipeState.isMealchosen = true;
                          // });
                          setState(() {
                            duration = enteredduratoin;
                          });
                        },
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            fillColor: Colors.grey[100],
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                            hintText: widget.recipe.duration,
                            hintStyle: const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 36, 36, 36)),
                            contentPadding: const EdgeInsets.all(15)),
                      )),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text("Servings",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(
                        minLines: 1,
                        onChanged: (enteredservings) {
                          // setState(() {
                          //   AddRecipeState.mealType = selectedItem!;

                          //   AddRecipeState.isMealchosen = true;
                          // });
                          setState(() {
                            servings = enteredservings;
                          });
                        },
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            // labelText: "Servings",
                            fillColor: Colors.grey[100],
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                            hintText: widget.recipe.servings,
                            hintStyle: const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 36, 36, 36)),
                            contentPadding: const EdgeInsets.all(15)),
                      )),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text("Ingredients",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _ingredientController,
                    minLines: 1,
                    maxLines: 10,
                    // validator: (ingredients) {
                    //   if (AddRecipeState.ingredientsList.isEmpty) {
                    //     return "*required field";
                    //   }

                    //   return null;
                    // }
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      // labelText: "Servings",
                      fillColor: Colors.grey[100],
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.red)),
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Add Ingredient',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (widget.recipe.ingredients
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
                  const SizedBox(height: 20),
                  Column(
                    children: _ingredients(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text("Instructions",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _instructionController,
                    minLines: 1,
                    maxLines: 10,
                    // validator: (ingredients) {
                    //   if (AddRecipeState.ingredientsList.isEmpty) {
                    //     return "*required field";
                    //   }

                    //   return null;
                    // }
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      // labelText: "Servings",
                      fillColor: Colors.grey[100],
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.red)),
                      contentPadding: const EdgeInsets.all(15),
                      // hintText: 'Add Step',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.paste_sharp,
                            color: Color(0xFFFA8072),
                          )),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          if (widget.recipe.instructions
                              .contains(_instructionController.text)) {
                            _editInstruction(_instructionController.text);
                          } else {
                            if (_instructionController.text != "") {
                              _addInstruction(_instructionController.text);
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
                  SizedBox(height: 20),
                  Container(
                      // constraints: const BoxConstraints(minHeight: 300),

                      child: Column(
                    children: _instructions(),
                  )),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        updateFields();
                      },
                      style: ElevatedButton.styleFrom(
                        // primary: const Color(0xFFFA8072),
                        backgroundColor: const Color(0xFFFA8072),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Container(
                  //     child: _isLoading
                  //         ? Loader(loadingTxt: 'Saving updates please wait...')
                  //         : Container())
                ]))));
  }
}
