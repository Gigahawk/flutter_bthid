enum Keycode {
  // Based on https://github.com/tmk/tmk_keyboard/blob/389b2d7ee890263a74962cb318f83150251bf91d/tmk_core/common/keycode.h
  // Also see https://usb.org/sites/default/files/hut1_2.pdf#page=83

  kcNo(0x00),
  kcRollOver(0x01),
  kcPostFail(0x02),
  kcUndefined(0x03),
  kcA(0x04),
  kcB(0x05),
  kcC(0x06),
  kcD(0x07),
  kcE(0x08),
  kcF(0x09),
  kcG(0x0A),
  kcH(0x0B),
  kcI(0x0C),
  kcJ(0x0D),
  kcK(0x0E),
  kcL(0x0F),
  kcM(0x10),
  kcN(0x11),
  kcO(0x12),
  kcP(0x13),
  kcQ(0x14),
  kcR(0x15),
  kcS(0x16),
  kcT(0x17),
  kcU(0x18),
  kcV(0x19),
  kcW(0x1A),
  kcX(0x1B),
  kcY(0x1C),
  kcZ(0x1D),
  kc1(0x1E),
  kc2(0x1F),
  kc3(0x20),
  kc4(0x21),
  kc5(0x22),
  kc6(0x23),
  kc7(0x24),
  kc8(0x25),
  kc9(0x26),
  kc0(0x27),
  kcEnter(0x28),
  kcEscape(0x29),
  kcBspace(0x2A),
  kcTab(0x2B),
  kcSpace(0x2C),
  kcMinus(0x2D),
  kcEqual(0x2E),
  kcLbracket(0x2F),
  kcRbracket(0x30),
  kcBslash(0x31), // \ (and |)
  kcNonusHash(0x32), // Non-US # and ~ (Typically near the Enter key)
  kcScolon(0x33), // ; (and :)
  kcQuote(0x34), // ' and "
  kcGrave(0x35), // Grave accent and tilde
  kcComma(0x36), // , and <
  kcDot(0x37), // . and >
  kcSlash(0x38), // / and ?
  kcCapslock(0x39),

  // Main Function Keys
  kcF1(0x3A),
  kcF2(0x3B),
  kcF3(0x3C),
  kcF4(0x3D),
  kcF5(0x3E),
  kcF6(0x3F),
  kcF7(0x40),
  kcF8(0x41),
  kcF9(0x42),
  kcF10(0x43),
  kcF11(0x44),
  kcF12(0x45),

  // Nav cluster
  kcPscreen(0x46),
  kcScrolllock(0x47),
  kcPause(0x48),
  kcInsert(0x49),
  kcHome(0x4A),
  kcPgup(0x4B),
  kcDelete(0x4C),
  kcEnd(0x4D),
  kcPgdown(0x4E),

  // Arrow keys
  kcRight(0x4F),
  kcLeft(0x50),
  kcDown(0x51),
  kcUp(0x52),

  // Keypad keys
  kcNumlock(0x53),
  kcKpSlash(0x54),
  kcKpAsterisk(0x55),
  kcKpMinus(0x56),
  kcKpPlus(0x57),
  kcKpEnter(0x58),
  kcKp1(0x59),
  kcKp2(0x5A),
  kcKp3(0x5B),
  kcKp4(0x5C),
  kcKp5(0x5D),
  kcKp6(0x5E),
  kcKp7(0x5F),
  kcKp8(0x60),
  kcKp9(0x61),
  kcKp0(0x62),
  kcKpDot(0x63),

  kcNonusBslash(0x64), // Non-US \ and | (Typically near the Left-Shift key)
  kcApplication(0x65),
  kcPower(0x66),

  // Keypad keys 2
  kcKpEqual(0x67),

  // Function keys 2
  kcF13(0x68),
  kcF14(0x69),
  kcF15(0x6A),
  kcF16(0x6B),
  kcF17(0x6C),
  kcF18(0x6D),
  kcF19(0x6E),
  kcF20(0x6F),
  kcF21(0x70),
  kcF22(0x71),
  kcF23(0x72),
  kcF24(0x73),

  kcExecute(0x74),
  kcHelp(0x75),
  kcMenu(0x76),
  kcSelect(0x77),
  kcStop(0x78),
  kcAgain(0x79),
  kcUndo(0x7A),
  kcCut(0x7B),
  kcCopy(0x7C),
  kcPaste(0x7D),
  kcFind(0x7E),
  kcMute(0x7F),
  kcVolup(0x80),
  kcVoldown(0x81),
  kcLockingCaps(0x82), // locking Caps Lock
  kcLockingNum(0x83), // locking Num Lock
  kcLockingScroll(0x84), // locking Scroll Lock

  // Keypad keys 3
  kcKpComma(0x85),
  kcKpEqualAs400(0x86), // equal sign on AS/400

  // International keys
  kcInt1(0x87),
  kcInt2(0x88),
  kcInt3(0x89),
  kcInt4(0x8A),
  kcInt5(0x8B),
  kcInt6(0x8C),
  kcInt7(0x8D),
  kcInt8(0x8E),
  kcInt9(0x8F),
  kcLang1(0x90),
  kcLang2(0x91),
  kcLang3(0x92),
  kcLang4(0x93),
  kcLang5(0x94),
  kcLang6(0x95),
  kcLang7(0x96),
  kcLang8(0x97),
  kcLang9(0x98),
  kcAltErase(0x99),
  kcSysreq(0x9A),
  kcCancel(0x9B),
  kcClear(0x9C),
  kcPrior(0x9D),
  kcReturn(0x9E),
  kcSeparator(0x9F),
  kcOut(0xA0),
  kcOper(0xA1),
  kcClearAgain(0xA2),
  kcCrsel(0xA3),
  kcExsel(0xA4),

  // A5-AF is reserved

  // Keypad keys 4
  kcKp00(0xB0),
  kcKp000(0xB1),
  kcThousandsSeparator(0xB2),
  kcDecimalSeparator(0xB3),
  kcCurrencyUnit(0xB4),
  kcCurrencySubUnit(0xB5),
  kcKpLparen(0xB6),
  kcKpRparen(0xB7),
  kcKpLcbracket(0xB8), // {
  kcKpRcbracket(0xB9), // }
  kcKpTab(0xBA),
  kcKpBspace(0xBB),
  kcKpA(0xBC),
  kcKpB(0xBD),
  kcKpC(0xBE),
  kcKpD(0xBF),
  kcKpE(0xC0),
  kcKpF(0xC1),
  kcKpXor(0xC2),
  kcKpHat(0xC3),
  kcKpPerc(0xC4),
  kcKpLt(0xC5),
  kcKpGt(0xC6),
  kcKpAnd(0xC7),
  kcKpLazyand(0xC8),
  kcKpOr(0xC9),
  kcKpLazyor(0xCA),
  kcKpColon(0xCB),
  kcKpHash(0xCC),
  kcKpSpace(0xCD),
  kcKpAtmark(0xCE),
  kcKpExclamation(0xCF),
  kcKpMemStore(0xD0),
  kcKpMemRecall(0xD1),
  kcKpMemClear(0xD2),
  kcKpMemAdd(0xD3),
  kcKpMemSub(0xD4),
  kcKpMemMul(0xD5),
  kcKpMemDiv(0xD6),
  kcKpPlusMinus(0xD7),
  kcKpClear(0xD8),
  kcKpClearEntry(0xD9),
  kcKpBinary(0xDA),
  kcKpOctal(0xDB),
  kcKpDecimal(0xDC),
  kcKpHexadecimal(0xDD),

  // DE-DF is reserved

  // Modifiers
  kcLctrl(0xE0),
  kcLshift(0xE1),
  kcLalt(0xE2),
  kcLgui(0xE3),
  kcRctrl(0xE4),
  kcRshift(0xE5),
  kcRalt(0xE6),
  kcRgui(0xE7);

  // E8 onwards is reserved

  final int value;
  const Keycode(this.value);
}

/// Returns a list of [Keycode]s required to produce the given [char].
///
/// If the character requires Shift (e.g., 'A' or '!'), the list will contain
/// [Keycode.kcLshift] followed by the base key.
List<Keycode> keycodeListFromChar(String char) {
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
    if (baseKey == Keycode.kcNo) return [];
    return isUppercaseAlpha ? [Keycode.kcLshift, baseKey] : [baseKey];
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
    return [Keycode.kcLshift, shiftMap[c]!];
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
    return [normalMap[c]!];
  }

  throw ArgumentError("No keycode mapping found for character: $c");
}

List<int> reportFromChar(String char) {
  return keycodeListFromChar(char).map((e) => e.value).toList();
}
