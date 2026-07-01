import 'package:flutter/material.dart';

class TrackpadSurface extends StatelessWidget {
  const TrackpadSurface({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      width: double.infinity,
      height: 250,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // so taps register even on empty space
        onPanDown: (details) {
          print('Finger down: ${details.localPosition}');
        },
        onPanUpdate: (details) {
          print(
            'Pos: ${details.localPosition}  Delta: ${details.delta}',
          );
        },
        onPanEnd: (details) {
          print('Finger up. Velocity: ${details.velocity}');
        },
      ),
    );
  }
}