#include <cstdio>
#include <chrono>

using namespace std::chrono;

const int MAX = 32;

unsigned int getDividersCnt(unsigned int n) {
  unsigned int d = 3, q, dRes, res = 1;
  while (!(n & 1)) { n >>= 1; res++; }
  while ((d * d) <= n) { q = n / d; if (n % d == 0) { dRes = 0;
    do { dRes += res; n = q; q /= d; } while (n % d == 0);
      res += dRes; } d += 2; } return n != 1 ? res << 1 : res; }

int main() { unsigned int i, nxt, DivCnt;
  printf("The first %d anti-primes plus are: ", MAX);
  auto st = steady_clock::now(); i = nxt = 1; do {
    if ((DivCnt = getDividersCnt(i)) == nxt ) { printf("%d ", i);
      if ((++nxt > 4) && (getDividersCnt(nxt) == 2))
        i = (1 << (nxt - 1)) - 1; } i++; } while (nxt <= MAX);
  printf("%d ms", (int)(duration<double>(steady_clock::now() - st).count() * 1000));
}
