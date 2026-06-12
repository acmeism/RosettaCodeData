bool steady(int n) {
  int mask = 1;
  for (int d = n; d != 0; d ~/= 10) mask *= 10;
  return (n * n) % mask == n;
}

void main() {
  for (int i = 1; i < 10000; i++) if (steady(i)) print('$i^2 = ${i * i}');
}
