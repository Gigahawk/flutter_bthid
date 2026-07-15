enum MouseButtonMask {
  LEFT_BUTTON(0x01),
  RIGHT_BUTTON(0x02),
  MIDDLE_BUTTON(0x04),
  BACK_BUTTON(0x08),
  FORWARD_BUTTON(0x10)
  ;


  const MouseButtonMask(this.value);

  final int value;
}
class MouseState {
  List<int> _report = [
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
  ];

  static const int buttonMaskOffset = 0;
  static const int moveDxOffset = 1;
  static const int moveDyOffset = 2;
  static const int scrollDyOffset = 3;
  static const int scrollDxOffset = 4;

  List<int> get report => List.unmodifiable(_report);
  set report(List<int> newReport) {
    assert(
      newReport.length == _report.length,
      "MouseState report size mismatch: expected ${_report.length} bytes, got ${newReport.length} bytes"
    );
    _report = List.from(newReport, growable: false);
  }

  List<int> mouseButton(MouseButtonMask button, bool pressed) {
    if (pressed) {
      _report[buttonMaskOffset] |= button.value;
    } else {
      _report[buttonMaskOffset] &= ~button.value;
    }
    return report;
  }

  bool isMouseButtonDown(MouseButtonMask button) {
    return (_report[buttonMaskOffset] & button.value) != 0;
  }

  List<int> move(int dx, int dy) {
    _report[moveDxOffset] = dx.clamp(-127, 127) & 0xFF;
    _report[moveDyOffset] = dy.clamp(-127, 127) & 0xFF;
    return report;
  }

  List<int> scroll(int dx, int dy) {
    _report[scrollDxOffset] = dx.clamp(-127, 127) & 0xFF;
    _report[scrollDyOffset] = dy.clamp(-127, 127) & 0xFF;
    return report;
  }

  List<int> resetMove() {
    return move(0, 0);
  }

  List<int> resetScroll() {
    return scroll(0, 0);
  }

}