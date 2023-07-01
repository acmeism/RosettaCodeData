void main() {
  for (int i = 1; i <= 10; i++)
  {
    stdout.printf("%d", i);
    stdout.printf(i == 10 ? "\n" : ", ");
  }
}
