void main() {

  int[,] a = new int[10, 10];
  bool broken = false;
  for (int i = 0; i < 10; i++)
    for (int j = 0; j < 10; j++)
      a[i, j] = Random.int_range(0, 21) % 20 + 1;

  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      stdout.printf(" %d", a[i, j]);
      if (a[i, j] == 20) {
        broken = true;
        break;
      }
    }
    stdout.printf("\n");
    if (broken) break;
  }
}
