void lindenmayer(String s, Map<String, String> rules, int count) {
  for (int i = 0; i < count; ++i) {
    print(s);
    String nxt = "";
    for (int j = 0; j < s.length; ++j) {
      String c = s[j];
      nxt += rules.putIfAbsent(c, () => c);
    }
    s = nxt;
  }
}

void main() {
  var rules = {"I": "M", "M": "MI"};
  lindenmayer("I", rules, 5);
}
