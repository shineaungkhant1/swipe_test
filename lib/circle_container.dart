import 'dart:developer';

import 'package:flutter/material.dart';

class WordCircle extends StatefulWidget {
  const WordCircle({super.key, required this.onDrawEnd});

  final Function(String word) onDrawEnd;

  @override
  State<WordCircle> createState() => WordCircleState();
}

class WordCircleState extends State<WordCircle> {
  Map<String, Rect> wordList = {};

  Map<String, Rect> wordContstraints = {
    "I": const Rect.fromLTWH(100, 0, 50, 50),
    "N": const Rect.fromLTWH(0, 100, 80, 80),
    "E": const Rect.fromLTWH(200, 100, 35, 35),
    "1C": const Rect.fromLTWH(40, 200, 90, 90),
    "2C": const Rect.fromLTWH(150, 200, 100, 40),
  };
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(300),
      child: GestureDetector(
        onPanStart: (d) => wordList.clear(),
        onPanEnd: (d) {
          final cut = wordList.keys.toSet().toList().map((e) => e.length > 1 ? e.substring(1) : e);
          widget.onDrawEnd(cut.join());
          wordList.clear();
          setState(() {});
        },
        onPanUpdate: (detail) {
          final touch = detail.localPosition;
          wordContstraints.entries.forEach((entry) {
            if (entry.value.contains(touch)) {
              wordList.putIfAbsent(entry.key, () => entry.value);
            }
          });
          setState(() {});
        },
        child: Container(
          // color: Colors.red,
          width: 300,
          height: 300,
          child: Stack(
            children: [
              ...wordContstraints.keys.map(
                    (key) => Positioned(
                  top: wordContstraints[key]!.top,
                  left: wordContstraints[key]!.left,
                  child: Container(
                    width: wordContstraints[key]!.width,
                    height: wordContstraints[key]!.height,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      color: Colors.red,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      key.length > 1 ? key.substring(1) : key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: LinesPainter(linesData: wordList),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinesPainter extends CustomPainter {
  final Map<String, Rect> linesData;
  const LinesPainter({required this.linesData});

  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    log('rebuild ; ${linesData}');

    linesData.keys.forEach((key) {
      final currentIndex = linesData.keys.toList().indexOf(key);
      if (currentIndex == linesData.keys.length - 1) return;
      canvas.drawLine(linesData[key]!.center, linesData[linesData.keys.toList()[1 + currentIndex]]!.center, pen);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}