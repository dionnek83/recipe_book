import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_book/model.dart';
import 'package:recipe_book/pages/recipedetails.dart';

import 'package:progressive_image/progressive_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/pages/update.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.only(left: 40, top: 40),
                  child: Text("Hi Tracy,",
                      style: GoogleFonts.sofia(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Color(0xFFFA8072)))),
                )),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  "What would you like to eat?",
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
                margin: const EdgeInsets.only(left: 40, right: 40),
                child: TextFormField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[30],
                        contentPadding: const EdgeInsets.all(20.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade100, width: 2),
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFFFA8072), width: 2),
                            borderRadius: BorderRadius.circular(30.0)),
                        hintText: 'Search Recipe',
                        hintStyle: TextStyle(color: Colors.grey[350]),
                        suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.close, color: Colors.grey[350])),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[350],
                        )))),
            getRecipes()
          ],
        ));
  }
}

// add recipes
// addRecipes() async {
//   // ignore: avoid_function_literals_in_foreach_calls
//   recipes.forEach((recipe) async {
//     Map<String, dynamic> data = <String, dynamic>{
//       "mealtype": recipe.mealtype,
//       "name": recipe.title,
//       "description": recipe.description,
//       "duration": recipe.duration,
//       "servings": recipe.servings,
//       "image": recipe.image,
//       "ingredients": recipe.ingredients,
//       "instructions": recipe.instructions,
//       "favourite": recipe.favourite,
//     };
// //recipe name,description, time,image,list of ingredients, list of instructions
//     await FirebaseFirestore.instance
//         .collection('recipes')
//         .doc()
//         .set(data)
//         .whenComplete(() => print("Recipe added to the database"))
//         .catchError((e) => print(e));
//   });
// }

Stream<List<Recipe>> retrieveRecipes() => FirebaseFirestore.instance
    .collection('recipes')
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((e) => Recipe.fromJson({
              "id": e.id,
              "name": e.data()["name"],
              "image": e.data()["image"],
              "description": e.data()["description"],
              "servings": e.data()["servings"],
              "mealtype": e.data()["mealtype"],
              "duration": e.data()["duration"],
              "ingredients": e.data()["ingredients"],
              "instructions": e.data()["instructions"],
              "favourite": e.data()["favourite"],
            }))
        .toList());

Widget getRecipes() {
  updateFavourites(recipe, docId) async {
    recipe.favourite = !recipe.favourite;

    return FirebaseFirestore.instance
        .collection('recipes')
        .doc(docId)
        .update({'favourite': recipe.favourite})
        .then((value) => print("Favourite Updated!!!"))
        .catchError((error) => print("Failed to update favourite: $error"));
  }

  Future deleteImage(String url) async {
    try {
      FirebaseStorage.instance
          .refFromURL(url)
          .delete()
          .then((value) => print("image has been deleted from firestore"));
    } catch (e) {
      print(e);
    }
  }

  deleteRecipe(docID, imageUrl, context) {
    return FirebaseFirestore.instance
        .collection('recipes')
        .doc(docID)
        .delete()
        .then((value) {
      deleteImage(imageUrl);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Recipe has been successfully deleted.')));
      // ignore: invalid_return_type_for_catch_error
    }).catchError((error) => print("Failed to delete Recipe: $error"));
  }

  return StreamBuilder<List<Recipe>>(
      stream: retrieveRecipes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(children: [
                const CircularProgressIndicator(color: Color(0xFFFA8072)),
                Text("Recipes Loading",
                    style: GoogleFonts.sofia(
                        textStyle: const TextStyle(
                      fontSize: 18,
                    )))
              ]));
        }

        if (snapshot.data!.isNotEmpty) {
          final recipes = snapshot.data!;

          return Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 10.0),
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      children: List<Widget>.generate(
                          recipes.length,
                          (index) => Container(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => RecipeDetails(
                                                recipe: recipes[index])));
                                  },
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: ProgressiveImage(
                                                  placeholder: const AssetImage(
                                                      'assets/placeholder.png'),
                                                  thumbnail: NetworkImage(
                                                      recipes[index].image),
                                                  image: NetworkImage(
                                                      recipes[index].image),
                                                  height: 100,
                                                  width: 150,
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover),
                                            ),
                                            Align(
                                                alignment: Alignment.topRight,
                                                child: PopupMenuButton(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5,
                                                      ),
                                                      height: 36,
                                                      width: 48,
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: const Icon(
                                                          Icons.more_vert,
                                                          size: 35,
                                                          color: Color(
                                                              0xFFFA8072)),
                                                    ),
                                                    onSelected: (value) {},
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                              onTap: () {},
                                                              child: Column(
                                                                  children: [
                                                                    FloatingActionButton
                                                                        .extended(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (_) => UpdateRecipe(recipe: recipes[index])));
                                                                      },
                                                                      label:
                                                                          const Text(
                                                                        "Edit",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .edit_outlined,
                                                                          color:
                                                                              Color(0xFFFA8072)),
                                                                      elevation:
                                                                          0.0,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    FloatingActionButton
                                                                        .extended(
                                                                      onPressed:
                                                                          () async {
                                                                        deleteRecipe(
                                                                            recipes[index].id,
                                                                            recipes[index].image,
                                                                            context);
                                                                      },
                                                                      label:
                                                                          const Text(
                                                                        "Delete",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .delete_outline,
                                                                          color:
                                                                              Color(0xFFFA8072)),
                                                                      elevation:
                                                                          0.0,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                    )
                                                                  ]))
                                                        ]))
                                          ],
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, bottom: 3),
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () {
                                                    updateFavourites(
                                                        recipes[index],
                                                        recipes[index].id);
                                                  },
                                                  icon: recipes[index].favourite
                                                      ? const Icon(
                                                          FluentIcons
                                                              .heart_28_filled,
                                                          size: 25,
                                                          color:
                                                              Color(0xFFFA8072),
                                                        )
                                                      : const Icon(
                                                          // icon: Icon(
                                                          FluentIcons
                                                              .heart_28_regular,
                                                          size: 25,
                                                          //  color: Color(0xFFFA8072),
                                                        )),
                                              Text(
                                                  "${recipes[index].duration} min",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ]),
                                        Flexible(
                                          child: Text(
                                            recipes[index].name,
                                            style: GoogleFonts.sofia(
                                                textStyle: const TextStyle(
                                              fontSize: 15,
                                            )),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 0.8),
                                        Flexible(
                                          child: Text(
                                            recipes[index].description,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ])))))));
        }

        return Center(
            child: Column(children: <Widget>[
          const SizedBox(
            height: 80,
          ),
          Image.asset(
            'assets/spagetti-bowl.png',
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 20,
          ),
          Text("You don't have any recipes yet.",
              style: GoogleFonts.sofia(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFA8072),
                ),
              )),
          const SizedBox(
            height: 60,
          ),
        ]));
      });
}
