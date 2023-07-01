static void example(int start, int stop, int increment, string comment) {
  const int MAX_ITER = 9;
  int iteration = 0;
  stdout.printf("%-50s", comment);
  for (int i = start; i <= stop; i += increment) {
    stdout.printf("%3d ", i);
    if (++iteration > MAX_ITER) break;
  }
  stdout.printf("\n");
}

void main () {
  example(-2, 2, 1, "Normal");
  example(-2, 2, 0, "Zero increment");
  example(-2, 2, -1, "Increments away from stop value");
  example(-2, 2, 10, "First increment is beyond stop value");
  example(2, -2, 1, "Start more than stop: positive increment");
  example(2, 2, 1, "Start equals stop: positive increment");
  example(2, 2, -1, "Start equals stop: negative increment");
  example(2, 2, 0, "Start equals stop: zero increment");
  example(0, 0, 0, "Start equals stop equal zero: zero increment");
}
