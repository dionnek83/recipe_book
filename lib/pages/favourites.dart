import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_book/model.dart';
import 'package:recipe_book/pages/recipedetails.dart';
import 'package:progressive_image/progressive_image.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  FavouritesState createState() => FavouritesState();
}

class FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
                child: Text(
              "Favourites",
              style: GoogleFonts.sofia(
                  textStyle:
                      const TextStyle(fontSize: 30, color: Color(0xFFFA8072))),
            )),
          ),
          const SizedBox(height: 20),
          getRecipes()
        ]));
  }
}

Stream<List<Recipe>> retrieveFavRecipes() => FirebaseFirestore.instance
    .collection('recipes')
    .where("favourite", isEqualTo: true)
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
      stream: retrieveFavRecipes(),
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
                                                                          () {},
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
                                                                          () {
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
                                                  onPressed: () async {
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
                                                          FluentIcons
                                                              .heart_28_regular,
                                                          size: 25,
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
          Text("You don't have any favourite recipes yet.",
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
