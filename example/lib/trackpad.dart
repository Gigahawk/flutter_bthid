import 'package:flutter/material.dart';

class TrackpadSurface extends StatelessWidget {
  const TrackpadSurface({super.key, this.color = Colors.blueGrey});

  final MaterialColor color;
  get decoration =>
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(16.0));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Trackpad surface area - takes up the rest of the space
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (details) {
              print('Finger down: ${details.localPosition}');
            },
            onPanUpdate: (details) {
              print('Pos: ${details.localPosition}  Delta: ${details.delta}');
            },
            onPanEnd: (details) {
              print('Finger up. Velocity: ${details.velocity}');
            },
            child: Container(
              margin: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: decoration,
              child: const Center(
                child: Icon(Icons.touch_app, size: 48, color: Colors.white24),
              ),
            ),
          ),
        ),
        // Click buttons - fixed height at the bottom
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: SizedBox(
            height: 100.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10.0,
              children: [
                // Left Click
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanDown: (details) {
                      print('Left click down');
                    },
                    onPanEnd: (details) {
                      print('Left click up');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: const Center(
                        child: Text(
                          "Left",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Right Click
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanDown: (details) {
                      print('Right click down');
                    },
                    onPanEnd: (details) {
                      print('Right click up');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: const Center(
                        child: Text(
                          "Right",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
