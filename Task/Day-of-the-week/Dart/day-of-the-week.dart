void main() {
  print('Yuletide holidays must be allowed in the following years:');
  for (var year = 2008; year < 2121; year++) {
    var date = DateTime(year, 12, 25);
    if (date.weekday == DateTime.sunday) {
      print(year);
    }
  }
}
