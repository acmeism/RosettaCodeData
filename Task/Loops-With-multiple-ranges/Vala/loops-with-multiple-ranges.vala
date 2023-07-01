const int CHARBIT = 8;
long prod = 1;
long sum = 0;

long labs(long n) {
  long mask = n >> ((long)sizeof(long) * CHARBIT - 1);
  return ((n + mask) ^ mask);
}

long lpow(long base_num, long exp)
{
  long result = 1;
  while (true)
  {
    if ((exp & 1) != 0) result *= base_num;
    exp >>= 1;
    if (exp == 0) break;
    base_num *= base_num;
  }
  return result;
}

void process(long j) {
  sum += labs(j);
  if (labs(prod) < (1 << 27) && j != 0) prod *= j;
}

void main() {
  const int x = 5;
  const int y = -5;
  const int z = -2;
  const int one = 1;
  const int three = 3;
  const int seven = 11;
  long p = lpow(11, x);

  for (int j = -three; j <= lpow(3, 3); j += three ) process(j);
  for (int j = -seven; j <= seven; j += x) process(j);
  for (int j = 555; j <= 550 - y; ++j) process(j);
  for (int j = 22; j >= -28; j -= three) process(j);
  for (int j = 1928; j <= 1939; ++j) process(j);
  for (int j = x; j >= y; j -= -z) process(j);
  for (long j = p; j <= p + one; ++j) process(j);
  stdout.printf("sum  = %10ld\n", sum);
  stdout.printf("prod = %10ld\n", prod);
}
