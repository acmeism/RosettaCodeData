void main() {
  List<List<int>> w = [];
  List<int> lst = [2, 3, 5, 7];
  int sum;
  StringBuffer result = StringBuffer();

  for (int x in lst) {
    w.add([x, x]);
  }

  while (w.isNotEmpty) {
    var i = w.removeAt(0);
    for (int x in lst) {
      sum = i[1] + x;
      if (sum == 13) {
        result.write('${i[0]}$x ');
      } else if (sum < 12) {
        w.add([i[0] * 10 + x, sum]);
      }
    }
  }

  print(result.toString().trim());
}
