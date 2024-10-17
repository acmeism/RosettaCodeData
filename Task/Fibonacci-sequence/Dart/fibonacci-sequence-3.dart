Iterable<int> fibonacci([int n = 1, int m = 1]) sync* {
  yield n;
  yield* fibonacci(m, n + m);
}

void main() => print(fibonacci().take(20));
