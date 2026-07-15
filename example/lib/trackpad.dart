import 'package:flutter/material.dart';
import 'package:flutter_bthid/flutter_bthid.dart';
import 'package:flutter_bthid/mouse_state.dart';

class TrackpadSurface extends StatelessWidget {
  TrackpadSurface({super.key, this.color = Colors.blueGrey});

  final BluetoothHidManager hidManager = BluetoothHidManager();

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
            onTap: () {
              print("Finger tapped");
              // TODO: Create a setting for this
              const Duration _clickDuration = Duration(milliseconds: 100);
              hidManager.clickMouseButton(MouseButtonMask.LEFT_BUTTON, _clickDuration);
            },
            onScaleUpdate: (details) {
              if (details.pointerCount == 1) {

                print('Finger drag, Pos: ${details.focalPoint}  Delta: ${details.focalPointDelta}');
                // TODO: Create setting for this
                double sensitivity = 1.5;
                double dx = details.focalPointDelta.dx * sensitivity;
                double dy = details.focalPointDelta.dy * sensitivity;

                // Don't scroll while we move
                hidManager.mouseState.resetScroll();
                // TODO: This stops working when we move the mouse too slowly,
                // Especially noticeable with two finger scrolling since focal
                // point between two fingers can be really slowly moved.
                // We should be banking all move commands into "queue" that
                // dispatches when integer amounts of movement have been recorded

                hidManager.moveMouse(dx.toInt(), dy.toInt());
              }
              else if (details.pointerCount == 2) {
                // TODO: support flipping scroll direction
                double sensitivity = 1.5;
                double dx = details.focalPointDelta.dx * sensitivity;
                double dy = details.focalPointDelta.dy * sensitivity;
                print("Scroll $dx, $dy");

                // Don't move while we scroll
                hidManager.mouseState.resetMove();
                hidManager.scrollMouse(dx.toInt(), dy.toInt());
              }
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
                      hidManager.mouseButton(MouseButtonMask.LEFT_BUTTON, true);
                    },
                    onPanEnd: (details) {
                      print('Left click up');
                      hidManager.mouseButton(MouseButtonMask.LEFT_BUTTON, false);
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
                      hidManager.mouseButton(MouseButtonMask.RIGHT_BUTTON, true);
                    },
                    onPanEnd: (details) {
                      print('Right click up');
                      hidManager.mouseButton(MouseButtonMask.RIGHT_BUTTON, false);
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
