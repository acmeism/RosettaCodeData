Iterable<int> fibonacci(int n) sync* {
  int a = 1, b = 1;

  for (int i = 0; i < n; i++) {
    yield a;

    int temp = a;
    a = b;
    b = temp + b;
  }
}

void main() => print(fibonacci(20));
