import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Loader extends StatelessWidget {
  Loader(
      {Key? key,
      this.opacity = 0.5,
      this.dismissibles = false,
      this.color = Colors.black,
      this.loadingTxt = 'Saving updates please wait...'})
      : super(key: key);

  final double opacity;
  final bool dismissibles;
  final Color color;
  final String loadingTxt;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: CircularPercentIndicator(
              animation: true,
              animationDuration: 10000,
              radius: 100.0,
              lineWidth: 20.0,
              percent: 1,
              center: const Text("100%"),
              progressColor: Color(0xFFFA8072),
              circularStrokeCap: CircularStrokeCap.round,
            )),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Text(loadingTxt,
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
            ),
          ],
        )),
      ],
    );
  }
}
