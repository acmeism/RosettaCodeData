for (int i = 1; i <= 10; i++) {
  stdout.printf("%d", i);
  if (i % 5 == 0) {
    stdout.printf("\n");
    continue;
  }
  stdout.printf(", ");
}
