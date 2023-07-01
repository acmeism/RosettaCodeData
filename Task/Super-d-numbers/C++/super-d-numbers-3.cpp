#include <cstdio>
#include <sstream>
#include <chrono>

using namespace std;
using namespace chrono;

struct LI { uint64_t a, b, c, d, e; }; const uint64_t Lm = 1e18;
auto st = steady_clock::now(); LI k[10][10];

string padZ(uint64_t x, int n = 18) { string r = to_string(x);
  return string(max((int)(n - r.length()), 0), '0') + r; }

uint64_t ipow(uint64_t b, uint64_t e) { uint64_t r = 1;
  while (e) { if (e & 1) r *= b; e >>= 1; b *= b; } return r; }

uint64_t fa(uint64_t x) { // factorial
  uint64_t r = 1; while (x > 1) r *= x--; return r; }

void set(LI &d, uint64_t s) { // d = s
  d.a = s; d.b = d.c = d.d = d.e = 0; }

void inc(LI &d, LI s) { // d += s
  d.a += s.a; while (d.a >= Lm) { d.a -= Lm; d.b++; }
  d.b += s.b; while (d.b >= Lm) { d.b -= Lm; d.c++; }
  d.c += s.c; while (d.c >= Lm) { d.c -= Lm; d.d++; }
  d.d += s.d; while (d.d >= Lm) { d.d -= Lm; d.e++; }
  d.e += s.e;
}

string scale(uint32_t s, LI &x) { // multiplies x by s, converts to string
  uint64_t A = x.a * s, B = x.b * s, C = x.c * s, D = x.d * s, E = x.e * s;
  while (A >= Lm) { A -= Lm; B++; }
  while (B >= Lm) { B -= Lm; C++; }
  while (C >= Lm) { C -= Lm; D++; }
  while (D >= Lm) { D -= Lm; E++; }
  if (E > 0) return to_string(E) + padZ(D) + padZ(C) + padZ(B) + padZ(A);
  if (D > 0) return to_string(D) + padZ(C) + padZ(B) + padZ(A);
  if (C > 0) return to_string(C) + padZ(B) + padZ(A);
  if (B > 0) return to_string(B) + padZ(A);
  return to_string(A);
}

void fun(int d) {
  auto m = k[d]; string s = string(d, '0' + d); printf("%d: ", d);
  for (int i = d, c = 0; c < 10; i++) {
    if (scale((uint32_t)d, m[0]).find(s) != string::npos) {
      printf("%d ", i); ++c; }
    for (int j = d, k = d - 1; j > 0; j = k--) inc(m[k], m[j]);
  } printf("%ss\n", to_string(duration<double>(steady_clock::now() - st).count()).substr(0,5).c_str());
}

static void init() {
  for (int v = 1; v < 10; v++) {
    uint64_t f[v + 1], l[v + 1];
    for (int j = 0; j <= v; j++) {
      if (j == v) for (int y = 0; y <= v; y++)
          set(k[v][y], v != y ? (uint64_t)f[y] : fa(v));
      l[0] = f[0]; f[0] = ipow(j + 1, v);
      for (int a = 0, b = 1; b <= v; a = b++) {
        l[b] = f[b]; f[b] = f[a] - l[a];
      }
    }
  }
}

int main() {
  init();
  for (int i = 2; i <= 9; i++) fun(i);
}
