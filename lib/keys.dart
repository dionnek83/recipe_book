import 'package:flutter/material.dart';

class Keys extends StatelessWidget {
  static final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  const Keys({Key? key}) : super(key: key);

  get getKeys {
    return _formKeys;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
