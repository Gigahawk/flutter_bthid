import 'keycode.dart';

enum ModifierMask {
  lCtrl(0x01),
  lShift(0x02),
  lAlt(0x04),
  lGui(0x08),
  rCtrl(0x10),
  rShift(0x20),
  rAlt(0x40),
  rGui(0x80);

  const ModifierMask(this.value);

  final int value;
}

class KeyboardState {
  int _modifierMask = 0;

  List<Keycode> _pressedKeys = [];

  int _ledMask = 0;

  static const int keyListLength = 6;

  bool get numLock => (_ledMask & 0x01) != 0;
  bool get capsLock => (_ledMask & 0x02) != 0;
  bool get scrollLock => (_ledMask & 0x04) != 0;

  List<int> get report {
    List<int> keyCodes = _pressedKeys.map((e) => e.value).toList();
    if (keyCodes.length > keyListLength) {
      keyCodes = keyCodes.sublist(0, keyListLength);
    } else if (keyCodes.length < keyListLength) {
      keyCodes.addAll(List.filled(keyListLength - keyCodes.length, 0x00));
    }

    return [
      _modifierMask,
      0x00,
      ...keyCodes
    ];
  }

  void setLedMask(int mask) {
    _ledMask = mask;
  }

  List<int> modifierButton(ModifierMask button, bool pressed) {
    if (pressed) {
      _modifierMask |= button.value;
    } else {
      _modifierMask &= ~button.value;
    }
    return report;
  }

  List<int> keyButton(Keycode key, bool pressed) {
    if (pressed) {
      if (_pressedKeys.contains(key)) return report;

      if (_pressedKeys.length >= 6) {
        // TODO: do we just let this fail silently?
        // throw Exception("Cannot press more than 6 keys at once");
        return report;
      }
      _pressedKeys.add(key);
    } else {
      _pressedKeys.remove(key);
    }
    return report;
  }

  List<int> resetKeys() {
    _pressedKeys = [];
    return report;
  }

  List<int> resetModifiers() {
    _modifierMask = 0;
    return report;
  }

  List<int> reset() {
    resetKeys();
    resetModifiers();
    return report;
  }

  List<int> pressKeyFromChar(String char) {
    assert(char.length == 1);
    final String c = char[0];

    // Helper to check for uppercase alpha
    final bool isUppercaseAlpha = RegExp(r'[A-Z]').hasMatch(c);

    // 1. Handle Alpha (A-Z, a-z)
    if (RegExp(r'[a-zA-Z]').hasMatch(c)) {
      final baseKey = Keycode.values.firstWhere(
            (e) => e.name == 'kc${c.toUpperCase()}',
        orElse: () => Keycode.kcNo,
      );
      if (baseKey == Keycode.kcNo) {
        throw ArgumentError("SHOULD NEVER HAPPEN: No keycode mapping found for character: $c");
      }
      keyButton(baseKey, true);
      if (isUppercaseAlpha) {
        modifierButton(ModifierMask.lShift, true);
      }
      return report;
    }

    // 2. Map for characters that REQUIRE Shift
    const shiftMap = {
      '!': Keycode.kc1,
      '@': Keycode.kc2,
      '#': Keycode.kc3,
      '\$': Keycode.kc4,
      '%': Keycode.kc5,
      '^': Keycode.kc6,
      '&': Keycode.kc7,
      '*': Keycode.kc8,
      '(': Keycode.kc9,
      ')': Keycode.kc0,
      '_': Keycode.kcMinus,
      '+': Keycode.kcEqual,
      '{': Keycode.kcLbracket,
      '}': Keycode.kcRbracket,
      '|': Keycode.kcBslash,
      ':': Keycode.kcScolon,
      '"': Keycode.kcQuote,
      '~': Keycode.kcGrave,
      '<': Keycode.kcComma,
      '>': Keycode.kcDot,
      '?': Keycode.kcSlash,
    };

    if (shiftMap.containsKey(c)) {
      keyButton(shiftMap[c]!, true);
      modifierButton(ModifierMask.lShift, true);
      return report;
    }

    // 3. Map for characters that do NOT require Shift
    const normalMap = {
      '1': Keycode.kc1,
      '2': Keycode.kc2,
      '3': Keycode.kc3,
      '4': Keycode.kc4,
      '5': Keycode.kc5,
      '6': Keycode.kc6,
      '7': Keycode.kc7,
      '8': Keycode.kc8,
      '9': Keycode.kc9,
      '0': Keycode.kc0,
      ' ': Keycode.kcSpace,
      '\n': Keycode.kcEnter,
      '\r': Keycode.kcEnter,
      '\t': Keycode.kcTab,
      '-': Keycode.kcMinus,
      '=': Keycode.kcEqual,
      '[': Keycode.kcLbracket,
      ']': Keycode.kcRbracket,
      '\\': Keycode.kcBslash,
      ';': Keycode.kcScolon,
      '\'': Keycode.kcQuote,
      '`': Keycode.kcGrave,
      ',': Keycode.kcComma,
      '.': Keycode.kcDot,
      '/': Keycode.kcSlash,
    };

    if (normalMap.containsKey(c)) {
      keyButton(normalMap[c]!, true);
      modifierButton(ModifierMask.lShift, false);
      return report;
    }

    throw ArgumentError("No keycode mapping found for character: $c");
  }

  KeyboardState({int ledMask = 0}) {
    setLedMask(ledMask);
  }
}
