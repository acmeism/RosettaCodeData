import 'package:unittest/unittest.dart';

String reverse(String s) => new String.fromCharCodes(s.runes.toList().reversed);

main() {
  group("Reverse a string -", () {
    test("Strings with ASCII characters are reversed correctly.", () {
      expect(reverse("hello, world"), equals("dlrow ,olleh"));
    });
    test("Strings with non-ASCII BMP characters are reversed correctly.", () {
      expect(reverse("\u4F60\u4EEC\u597D"), equals("\u597D\u4EEC\u4F60"));
    });
    test("Strings with non-BMP characters are reversed correctly.", () {
      expect(reverse("hello, \u{1F310}"), equals("\u{1F310} ,olleh"));
    });
  });
}
