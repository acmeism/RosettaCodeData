main() {
  var total = 0;
  var empty = <int>[];
  for (var year = 1900; year < 2101; year++) {
    var months =
        [1, 3, 5, 7, 8, 10, 12].where((m) => DateTime(year, m, 1).weekday == 5);
    print('$year\t$months');
    total += months.length;
    if (months.isEmpty) empty.add(year);
  }
  print('Total: $total');
  print('Year with none: $empty');
}
