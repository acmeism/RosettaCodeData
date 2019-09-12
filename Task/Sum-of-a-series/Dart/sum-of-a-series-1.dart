main() {
  var list = new List<int>.generate(1000, (i) => i + 1);

  num sum = 0;

  (list.map((x) => 1.0 / (x * x))).forEach((num e) {
    sum += e;
  });
  print(sum);
}
