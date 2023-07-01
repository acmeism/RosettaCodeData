int F(int n, int x, int y) {
  if (n == 0) {
    return x + y;
  } else if (y == 0) {
    return x;
  }

  return F(n - 1, F(n, x, y - 1), F(n, x, y - 1) + y);
}

void main() {
  print('F(1,3,3) = ${F(1, 3, 3)}');
}
