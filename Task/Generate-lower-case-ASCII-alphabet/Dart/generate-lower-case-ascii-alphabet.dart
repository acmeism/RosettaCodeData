void main() {
  List<String> lower =
      List.generate(26, (index) => String.fromCharCode(97 + index));
  print(lower);
}
