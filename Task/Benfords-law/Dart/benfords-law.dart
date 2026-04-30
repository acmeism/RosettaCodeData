import 'dart:math';

digits(n) sync* {
  double a = 0, b = 1;
  for (var i = 0; i < n; i++) {
    yield b.toString().codeUnitAt(0) - 48;
    (a, b) = (b, a + b);
  }
}

lineout(s1, s2, s3) {
  print(
    s1.toString().padLeft(8) +
        s2.toString().padLeft(12) +
        s3.toString().padLeft(12),
  );
}

main() {
  var tally = List<int>.filled(9, 0);
  for (var d in digits(1000)) {
    tally[d - 1] += 1;
  }

  lineout("Digit", "Expected", "Actual");
  print("-" * 40);

  for (var d = 1; d < 10; d += 1) {
    lineout(
      d,
      (log(1 + 1 / d) * log10e).toStringAsFixed(4),
      (tally[d - 1] / 1000).toStringAsFixed(3),
    );
  }
}
