#include <chrono>
#include <cmath>
#include <locale>

using UI = unsigned long long;
using namespace std;
using namespace chrono;

int limc = 877;

const double l2 = log(2), l3 = log(3), l5 = log(5), l7 = log(7), l0 = log(10), fac = 1e12;

static bool IsHum(int num) { if (num <= 1) return true; for (int j : { 2, 3, 5, 7 })
  if (num % j == 0) return IsHum(num / j); return false; }

// slow way to determine whether numbers are humble numbers
static void First_Slow(int firstAmt) { printf("The first %d humble numbers are: ", firstAmt);
  for (int gg = 0, g = 1; gg < firstAmt; g++) if (IsHum(g)) { printf("%d ", g); gg++; }
  printf("\n\n"); }

int main(int argc, char **argv) {
  First_Slow(50); setlocale(LC_ALL, ""); auto st = steady_clock::now();
  if (argc > 1) limc = stoi(argv[1]);
  UI *bins = new UI[limc],     lb0 = (UI)round(fac * l0),
    lb2 = (UI)round(fac * l2), lb3 = (UI)round(fac * l3),
    lb5 = (UI)round(fac * l5), lb7 = (UI)round(fac * l7),
    tot = 0, lmt = limc * lb0, lm2 = lb5 * 3;
  printf("Digits       Count              Accum\n");
  for (int g = 0; g < limc; g++) bins[g] = 0;
  for (UI i = 0; i < lmt; i += lb2) for (UI j = i; j < lmt; j += lb3)
  for (UI k = j; k < lmt; k += lb5) for (UI l = k; l < lmt; l += lb7)
    bins[l / lb0]++;
  for (int f = 0, g = 1; f < limc; f = g++) { tot += bins[f];
    //if (g < 110 || g % 100 == 0 || (g < 200 && g % 10 == 0)) // uncomment to emulate pascal output
      printf ("%4d %'13llu %'18llu\n", g, bins[f], tot); }
  delete [] bins;
  printf("Counting took %8f seconds\n", duration<double>(steady_clock::now() - st).count());
}
