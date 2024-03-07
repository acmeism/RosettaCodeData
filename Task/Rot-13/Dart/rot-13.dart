String rot13char(int charCode) {
  if ((charCode >= 'A'.codeUnitAt(0) && charCode <= 'M'.codeUnitAt(0)) ||
      (charCode >= 'a'.codeUnitAt(0) && charCode <= 'm'.codeUnitAt(0))) {
    return String.fromCharCode(charCode + 13);
  } else if ((charCode >= 'N'.codeUnitAt(0) && charCode <= 'Z'.codeUnitAt(0)) ||
             (charCode >= 'n'.codeUnitAt(0) && charCode <= 'z'.codeUnitAt(0))) {
    return String.fromCharCode(charCode - 13);
  } else {
    return String.fromCharCode(charCode);
  }
}

String rot13(String str) {
  return String.fromCharCodes(str.runes.map((rune) {
    return rot13char(rune).codeUnitAt(0);
  }));
}

void main() {
  print(rot13("The quick brown fox jumps over the lazy dog"));
}
