#include <chrono>
#include <iostream>

using namespace std;
using namespace chrono;

const long long Lm = (long)1e18;
const int Fm = 18;

struct LI { long long lo, ml, mh, hi, tp; };

LI set(long long s) { LI d;
  d.lo = s; d.ml = d.mh = d.hi = d.tp = 0; return d; }

void inc(LI& d, LI s) { // d += s
  if ((d.lo += s.lo) >= Lm) { d.ml++; d.lo -= Lm; }
  if ((d.ml += s.ml) >= Lm) { d.mh++; d.ml -= Lm; }
  if ((d.mh += s.mh) >= Lm) { d.hi++; d.mh -= Lm; }
  if ((d.hi += s.hi) >= Lm) { d.tp++; d.hi -= Lm; }
  d.tp += s.tp;
}

void dec(LI& d, LI s) { // d -= s
  if ((d.lo -= s.lo) < 0) { d.ml--; d.lo += Lm; }
  if ((d.ml -= s.ml) < 0) { d.mh--; d.ml += Lm; }
  if ((d.mh -= s.mh) < 0) { d.hi--; d.mh += Lm; }
  if ((d.hi -= s.hi) < 0) { d.tp--; d.hi += Lm; }
  d.tp -= s.tp;
}

inline string sf(long long n) {
  int len = Fm;
  string result(len--, '0');
  for (long long i = n; len >= 0 && i > 0; --len, i /= 10)
    result[len] = '0' + i % 10;
  return result;
}

string fmt(LI x) { // returns formatted string value of x
  if (x.tp > 0) return to_string(x.tp) + sf(x.hi) + sf(x.mh) + sf(x.ml) + sf(x.lo);
  if (x.hi > 0) return to_string(x.hi) + sf(x.mh) + sf(x.ml) + sf(x.lo);
  if (x.mh > 0) return to_string(x.mh) + sf(x.ml) + sf(x.lo);
  if (x.ml > 0) return to_string(x.ml) + sf(x.lo);
  return to_string(x.lo);
}

LI partcount(int n) { LI p[n + 1]; p[0] = set(1);
  for (int i = 1; i <= n; i++) {
    int k = 0, d = -2, j = i; LI x = set(0); while (true) {
      if ((j -= (d += 3) - k) >= 0) inc(x, p[j]); else break;
      if ((j -= ++k)          >= 0) inc(x, p[j]); else break;
      if ((j -= (d += 3) - k) >= 0) dec(x, p[j]); else break;
      if ((j -= ++k)          >= 0) dec(x, p[j]); else break;
    } p[i] = x; } return p[n]; }

int main() {
  auto start = steady_clock::now();
  auto result = partcount(6666);
  auto end = steady_clock::now();
  duration<double, milli> ms(end - start);
  cout << fmt(result) << "  " << ms.count() << " ms";
}
