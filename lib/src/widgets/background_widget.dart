import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color(0xffaaffee),
      child: SvgPicture.asset(
        'assets/bg-home.svg',
        fit: BoxFit.fitWidth,
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}