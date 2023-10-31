import 'package:flutter/material.dart';
import 'package:recipe_book/model.dart';

class Ingredients extends StatelessWidget {
  const Ingredients({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(children: [
          ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: recipe.ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: Text(
                    "• ${recipe.ingredients[index]}",
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Colors.grey.shade200);
              })
        ]),
      ),
    );
  }
}
