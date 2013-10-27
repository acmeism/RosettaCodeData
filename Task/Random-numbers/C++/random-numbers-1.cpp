#include <random>
#include <functional>
#include <vector>
#include <algorithm>
using namespace std;

int main()
{
  random_device seed;
  mt19937 engine(seed());
  normal_distribution<double> dist(1.0, 0.5);
  auto rnd = bind(dist, engine);

  vector<double> v(1000);
  generate(v.begin(), v.end(), rnd);
  return 0;
}
