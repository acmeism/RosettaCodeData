void main() {
  String lowercase = '';
  for (var c = 0x61; c < 0x7b; c++) lowercase += String.fromCharCode(c);
  print(lowercase);

  String uppercase = '';
  for (var c = 0x41; c < 0x5b; c++) uppercase += String.fromCharCode(c);
  print(uppercase);
}
