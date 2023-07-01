String capitalize(String string) {
  if (string.isEmpty) {
    return string;
  }
  return string[0].toUpperCase() + string.substring(1);
}

void main() {
  var s = 'alphaBETA';
  print('Original string: $s');
  print('To Lower case:   ${s.toLowerCase()}');
  print('To Upper case:   ${s.toUpperCase()}');
  print('To Capitalize:   ${capitalize(s)}');
}
