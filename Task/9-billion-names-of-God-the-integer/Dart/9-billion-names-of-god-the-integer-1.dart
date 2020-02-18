import 'dart:math';

List<BigInt> partitions(int n) {
  var cache = List<List<BigInt>>.filled(1, List<BigInt>.filled(1, BigInt.from(1)), growable: true);
  for(int length = cache.length; length < n + 1; length++) {
    var row = List<BigInt>.filled(1, BigInt.from(0), growable: true);
    for(int index = 1; index < length + 1; index++) {
      var partAtIndex = row[row.length - 1] + cache[length - index][min(index, length - index)];
      row.add(partAtIndex);
    }
    cache.add(row);
  }
  return cache[n];
}

List<BigInt> row(int n) {
  var parts = partitions(n);
  return List<BigInt>.generate(n, (int index) => parts[index + 1] - parts[index]);
}

void printRows({int min = 1, int max = 11}) {
  int maxDigits = max.toString().length;
  print('Rows:');
  for(int i in List.generate(max - min, (int index) => index + min)) {
    print((' ' * (maxDigits - i.toString().length)) + '$i: ${row(i)}');
  }
}

void printSums(List<int> args) {
  print('Sums:');
  for(int i in args) {
    print('$i: ${partitions(i)[i]}');
  }
}
