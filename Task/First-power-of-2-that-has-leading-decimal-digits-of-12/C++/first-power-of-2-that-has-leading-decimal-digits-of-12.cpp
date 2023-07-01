// a mini chrestomathy solution

#include <string>
#include <chrono>
#include <cmath>
#include <locale>

using namespace std;
using namespace chrono;

// translated from java example
unsigned int js(int l, int n) {
  unsigned int res = 0, f = 1;
  double lf = log(2) / log(10), ip;
  for (int i = l; i > 10; i /= 10) f *= 10;
  while (n > 0)
    if ((int)(f * pow(10, modf(++res * lf, &ip))) == l) n--;
  return res;
}

// translated from go integer example (a.k.a. go translation of pascal alternative example)
unsigned int gi(int ld, int n) {
  string Ls = to_string(ld);
  unsigned int res = 0, count = 0; unsigned long long f = 1;
  for (int i = 1; i <= 18 - Ls.length(); i++) f *= 10;
  const unsigned long long ten18 = 1e18; unsigned long long probe = 1;
  do {
    probe <<= 1; res++; if (probe >= ten18) {
      do {
        if (probe >= ten18) probe /= 10;
        if (probe / f == ld) if (++count >= n) { count--; break; }
        probe <<= 1; res++;
      } while (1);
    }
    string ps = to_string(probe);
    if (ps.substr(0, min(Ls.length(), ps.length())) == Ls) if (++count >= n) break;
  } while (1);
  return res;
}

// translated from pascal alternative example
unsigned int pa(int ld, int n) {
  const double L_float64 = pow(2, 64);
  const unsigned long long Log10_2_64 = (unsigned long long)(L_float64 * log(2) / log(10));
  double Log10Num; unsigned long long LmtUpper, LmtLower, Frac64;
  int res = 0, dgts = 1, cnt;
  for (int i = ld; i >= 10; i /= 10) dgts *= 10;
  Log10Num = log((ld + 1.0) / dgts) / log(10);
  // '316' was a limit
  if (Log10Num >= 0.5) {
    LmtUpper = (ld + 1.0) / dgts < 10.0 ? (unsigned long long)(Log10Num * (L_float64 * 0.5)) * 2 + (unsigned long long)(Log10Num * 2) : 0;
    Log10Num = log((double)ld / dgts) / log(10);
    LmtLower = (unsigned long long)(Log10Num * (L_float64 * 0.5)) * 2 + (unsigned long long)(Log10Num * 2);
  } else {
    LmtUpper = (unsigned long long)(Log10Num * L_float64);
    LmtLower = (unsigned long long)(log((double)ld / dgts) / log(10) * L_float64);
  }
  cnt = 0; Frac64 = 0; if (LmtUpper != 0) {
    do {
      res++; Frac64 += Log10_2_64;
      if ((Frac64 >= LmtLower) & (Frac64 < LmtUpper))
        if (++cnt >= n) break;
    } while (1);
  } else { // '999..'
    do {
      res++; Frac64 += Log10_2_64;
      if (Frac64 >= LmtLower) if (++cnt >= n) break;
    } while (1);
  };
  return res;
}

int params[] = { 12, 1, 12, 2, 123, 45, 123, 12345, 123, 678910, 99, 1 };

void doOne(string name, unsigned int (*func)(int a, int b)) {
  printf("%s version:\n", name.c_str());
  auto start = steady_clock::now();
  for (int i = 0; i < size(params); i += 2)
    printf("p(%3d, %6d) = %'11u\n", params[i], params[i + 1], func(params[i], params[i + 1]));
  printf("Took %f seconds\n\n", duration<double>(steady_clock::now() - start).count());
}

int main() {
  setlocale(LC_ALL, "");
  doOne("java simple", js);
  doOne("go integer", gi);
  doOne("pascal alternative", pa);
}
