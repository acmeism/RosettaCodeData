uint64 ackermann(uint64 m, uint64 n) {
  if (m == 0) return n + 1;
  if (n == 0) return ackermann(m - 1, 1);
  return ackermann(m - 1, ackermann(m, n - 1));
}

void main () {
  for (uint64 m = 0; m < 4; ++m) {
    for (uint64 n = 0; n < 10; ++n) {
      print(@"A($m,$n) = $(ackermann(m,n))\n");
    }
  }
}
