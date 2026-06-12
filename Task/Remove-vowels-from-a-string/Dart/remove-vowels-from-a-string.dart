void main() {
  test("Dart Programming Language");
}

class PrintNoVowels {
  final String str;

  PrintNoVowels(this.str);

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      String c = str[i];
      switch (c) {
        case 'A':
        case 'E':
        case 'I':
        case 'O':
        case 'U':
        case 'a':
        case 'e':
        case 'i':
        case 'o':
        case 'u':
          break;
        default:
          buffer.write(c);
          break;
      }
    }
    return buffer.toString();
  }
}

void test(String s) {
  print("Input  : $s");
  print("Output : ${PrintNoVowels(s)}");
}
