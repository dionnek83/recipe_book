import 'package:flutter/material.dart';

class StepProgressView extends StatelessWidget {
  final double _width;
  final List<IconData> _icons;
  final List<String> _titles;
  final int _curStep;
  final Color _activeColor;
  final Color _inactiveColor = Colors.grey[100]!;
  final double lineWidth = 4.0;

  StepProgressView(
      {Key? key,
      required List<IconData> icons,
      required int curStep,
      required List<String> titles,
      required double width,
      required Color color})
      : _icons = icons,
        _titles = titles,
        _curStep = curStep,
        _width = width,
        _activeColor = color,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          top: 32.0,
          left: 24.0,
          right: 24.0,
        ),
        width: _width,
        child: Column(
          children: <Widget>[
            Row(
              children: _iconViews(),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _titleViews(),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    _icons.asMap().forEach((i, icon) {
      var circleColor =
          (i == 0 || _curStep > i) ? _activeColor : _inactiveColor;

      var lineColor = _curStep > i ? _activeColor : _inactiveColor;

      var iconColor = (i == 0 || _curStep > i) ? _inactiveColor : _activeColor;

      list.add(
        Container(
          width: 30.0,
          height: 30.0,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: circleColor,
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
            border: Border.all(
              color: _activeColor,
              width: 2.0,
            ),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 15.0,
          ),
        ),
      );

      //line between icons
      if (i != _icons.length - 1) {
        list.add(Expanded(
            child: Container(
          height: lineWidth,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      list.add(Text(text, style: TextStyle(color: _activeColor)));
    });
    return list;
  }
}
