import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_book/keys.dart';
import '../pages/addrecipe.dart';

class Instructions extends StatefulWidget {
  const Instructions({Key? key}) : super(key: key);

  @override
  InstructionState createState() => InstructionState();
}

class InstructionState extends State<Instructions> {
  final TextEditingController _instructionController = TextEditingController();
  final List<String> instructions = <String>[];

  void _addTodoItem(String title) {
    setState(() {
      AddRecipeState.instructionsList.add(title);
    });
    _instructionController.clear();
  }

  Widget _buildTodoItem(String title) {
    return ListTile(title: Text(title));
  }

  List<Widget> _getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (String title in instructions) {
      _todoWidgets.add(_buildTodoItem(title));
    }
    return _todoWidgets;
  }

  void _removeInstruction(String title) {
    setState(() {
      AddRecipeState.instructionsList.remove(title);
    });
  }

  void _editInstruction(String title) {
    setState(() {
      _instructionController.text = title;
    });
    _removeInstruction(title);
  }

  List<Widget> _instructions() {
    var list = <Widget>[];
    AddRecipeState.instructionsList.asMap().forEach((i, text) {
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
                      _editInstruction(text);
                    },
                    icon: const Icon(Icons.edit, color: Colors.white)),
                IconButton(
                    onPressed: () {
                      _removeInstruction(text);
                    },
                    icon: const Icon(Icons.delete, color: Colors.white)),
              ],
            ),
          )));
    });
    return list;
  }

  Keys ke = Keys();
  String pasteValue = '';

  @override
  Widget build(BuildContext context) {
    return Form(
        key: AddRecipeState.formKeys[2],
        child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text("Instructions",
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
          TextFormField(
            controller: _instructionController,
            validator: (instructions) {
              if (AddRecipeState.instructionsList.isEmpty) {
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
              hintText: 'Add Step',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              prefixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.paste_sharp,
                    color: Color(0xFFFA8072),
                  )),
              suffixIcon: IconButton(
                onPressed: () async {
                  if (AddRecipeState.instructionsList
                      .contains(_instructionController.text)) {
                    _editInstruction(_instructionController.text);
                  } else {
                    if (_instructionController.text != "") {
                      _addTodoItem(_instructionController.text);
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
            child: Text("Steps",
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
            constraints: const BoxConstraints(minHeight: 165),
            child: Column(
              children: _instructions(),
            ),
          )
        ]));
  }
}

// class Ingredient {
//   Ingredient({required this.name, required this.checked});
//   final String name;
//   bool checked;
// }
