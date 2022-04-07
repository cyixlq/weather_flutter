import 'package:flutter/material.dart';

class WeatherItemCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double marginStart;
  final double marginEnd;

  const WeatherItemCard({
    Key? key,
    required this.title,
    required this.child,
    this.marginEnd = 0,
    this.marginStart = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10, left: marginStart, right: marginEnd),
      decoration: const BoxDecoration(
        color: Color(0x66ffffff),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          Center(
            child: child,
          ),
        ],
      ),
    );
  }
}
