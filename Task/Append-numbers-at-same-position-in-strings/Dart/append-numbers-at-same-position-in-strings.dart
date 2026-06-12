void main() {
  List<List<int>> list = List.generate(3, (_) => List.filled(9, 0));
  for (int i = 0; i < 27; i++) {
    list[i ~/ 9][i % 9] = 1 + i;
  }
  for (int i = 0; i < 9; i++) {
    print('${list[0][i]}${list[1][i]}${list[2][i]}  ');
  }
}
