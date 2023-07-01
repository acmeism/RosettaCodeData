int count_divisors(int n) {
  if (n < 2) return 1;
  var count = 2;
  for (int i = 2; i <= n/2; ++i)
    if (n%i == 0) ++count;
  return count;
}
void main() {
  var max_div = 0;
  var count = 0;
  stdout.printf("The first 20 anti-primes are:\n");
  for (int n = 1; count < 20; ++n) {
    var d = count_divisors(n);
    if (d > max_div) {
      stdout.printf("%d ", n);
      max_div = d;
      count++;
    }
  }
  stdout.printf("\n");
}
