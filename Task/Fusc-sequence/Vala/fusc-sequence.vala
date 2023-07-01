int fusc(int n) {
  if (n == 0 || n == 1)
    return n;
  else if (n % 2 == 0)
    return fusc(n / 2);
  else
    return fusc((n - 1) / 2) + fusc((n + 1) / 2);
}

void main() {
  print("The first 61 fusc numbers:\n");
  for (int i = 0; i < 61; i++)
    print(@"$(fusc(i)) ");
  print("\n\nThe fusc numbers whose lengths are greater than those of previous fusc numbers:\n");
  print("        n   fusc(n)\n");
  print("-------------------\n");
  var max_length = 0;
  for (int i = 0; i < 700000; i++) {
    var f = fusc(i);
    var length = f.to_string().length;
    if (length > max_length) {
      max_length = length;
      print("%9d %9d\n", i, f);
    }
  }
}
