#include <iostream>
#include <cmath>
#include <chrono>

using namespace std;
using namespace chrono;

int main() {
  auto st = high_resolution_clock::now();
  const uint i5 = 100000, i4 = 10000, i3 = 1000, i2 = 100, i1 = 10;
  uint p4[] = { 0, 1, 32, 243 }, nums[10], p5[10], t = 0,
    m5, m4, m3, m2, m1, m0; m5 = m4 = m3 = m2 = m1 = m0 = 0;
  for (uint i = 0; i < 10; i++) p5[i] = pow(nums[i] = i, 5);
  for (auto i : p4) { auto im =      m5, ip =      i; m4 = 0;
  for (auto j : p5) { auto jm = im + m4, jp = ip + j; m3 = 0;
  for (auto k : p5) { auto km = jm + m3, kp = jp + k; m2 = 0;
  for (auto l : p5) { auto lm = km + m2, lp = kp + l; m1 = 0;
  for (auto m : p5) { auto mm = lm + m1, mp = lp + m; m0 = 0;
  for (auto n : p5) { auto nm = mm + m0++;
    if (nm == mp + n && nm > 1) t += nm;
  } m1 += i1; } m2 += i2; } m3 += i3; } m4 += i4; } m5 += i5; }
  auto et = high_resolution_clock::now();
  std::cout << t << " " <<
    duration_cast<nanoseconds>(et - st).count() / 1000.0 << " μs";
}
