import 'package:flutter/material.dart';
import 'package:flutter_bthid/flutter_bthid.dart';
import 'package:flutter_bthid/mouse_state.dart';

class TrackpadSurface extends StatefulWidget {
  const TrackpadSurface({super.key, this.color = Colors.blueGrey});
  final MaterialColor color;

  @override
  State<TrackpadSurface> createState() => _TrackpadSurfaceState();
}

class _TrackpadSurfaceState extends State<TrackpadSurface> {

  final BluetoothHidManager hidManager = BluetoothHidManager();

  double _moveRemainderDx = 0.0;
  double _moveRemainderDy = 0.0;
  double _scrollRemainderDx = 0.0;
  double _scrollRemainderDy = 0.0;

  void _resetScroll() {
    _scrollRemainderDx = 0.0;
    _scrollRemainderDy = 0.0;
    hidManager.mouseState.resetScroll();
  }

  void _resetMove() {
    _moveRemainderDx = 0.0;
    _moveRemainderDy = 0.0;
    hidManager.mouseState.resetMove();
  }

  get decoration =>
      BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(16.0));

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
                _moveRemainderDx += details.focalPointDelta.dx * sensitivity;
                _moveRemainderDy += details.focalPointDelta.dy * sensitivity;

                // Don't scroll while we move
                _resetScroll();

                if (_moveRemainderDx.abs() < 1.0 && _moveRemainderDy.abs() < 1.0) {
                  return;
                }

                int dx = _moveRemainderDx.truncate();
                int dy = _moveRemainderDy.truncate();
                _moveRemainderDx -= dx;
                _moveRemainderDy -= dy;

                hidManager.moveMouse(dx.toInt(), dy.toInt());
              }
              else if (details.pointerCount == 2) {
                // TODO: support flipping scroll direction
                double sensitivity = 0.3;
                _scrollRemainderDx += details.focalPointDelta.dx * sensitivity;
                _scrollRemainderDy += details.focalPointDelta.dy * sensitivity;

                // Don't move while we scroll
                _resetMove();

                if (_scrollRemainderDx.abs() < 1.0 && _scrollRemainderDy.abs() < 1.0) {
                  return;
                }

                int dx = _scrollRemainderDx.truncate();
                int dy = _scrollRemainderDy.truncate();
                print("Scroll $dx, $dy");
                _scrollRemainderDx -= dx;
                _scrollRemainderDy -= dy;

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
                        color: widget.color,
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
                        color: widget.color,
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
