BigInt partitions(n) {
  var p = List.filled(n + 1, BigInt.zero);
  p[0] = BigInt.one;
  for (var i = 1; i < n + 1; i++) {
    var k = 0;
    while (true) {
      k += 1;
      var j = (k * (3 * k - 1)) ~/ 2;
      if (j > i) break;
      var t = p[i - j];
      p[i] = (p[i] + ((k % 2 == 1) ? t : -t)) ;
      j = (k * (3 * k + 1)) ~/ 2;
      if (j > i) break;
      t = p[i - j];
      p[i] = (p[i] + ((k % 2 == 1) ? t : -t));
    }
  }
  return p[n];
}

main() =>  print(partitions(6666));
