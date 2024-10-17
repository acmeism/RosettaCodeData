Iterable<int> fibonacci() sync* {
  int a = 1, b = 1;

  while (true) {
    yield a;

    int temp = a;
    a = b;
    b = temp + b;
  }
}

void main() => print(fibonacci().take(20));
