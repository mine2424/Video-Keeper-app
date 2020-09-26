import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Chart extends StatelessWidget {

  final List<double> data;

  const Chart({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipPath(
        clipper: ChartClipper(
          data: data,
          maxValue: data.reduce(max),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF2E7FE),
                // const Color(0xFFD7B7FD),
                const Color(0xFFBB86FC),
                // const Color(0xFF9E55FC),
                const Color(0xFF7F22FD),
                // const Color(0xFF6200EE),
                const Color(0xFF3700B3),
                // const Color(0xFF270096),
                const Color(0xFF190078),
              ]
            )
          ),
        ),
      ),
    );
  }
}

class ChartClipper extends CustomClipper<Path> {

  final double maxValue;
  final List<double> data;

  ChartClipper({this.maxValue, this.data});


  @override
  Path getClip(Size size) {
    double sectionWidth = size.width / (data.length - 1);
    Path path = Path();

    path.moveTo(0, size.height);

    for (int i = 0; i < data.length; i++) {
      path.lineTo(i * sectionWidth, size.height - size.height * (data[i]/maxValue));
    }

    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
