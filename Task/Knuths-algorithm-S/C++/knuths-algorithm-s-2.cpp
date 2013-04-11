#include <iostream>
#include <vector>
#include <cstdlib>
#include <ctime>

template <typename T>
class SOfN {
  std::vector<T> sample;
  int i;
  const int n;
 public:
  SOfN(int _n) : i(0), n(_n) { }
  std::vector<T> operator()(T item) {
    i++;
    if (i <= n) {
      sample.push_back(item);
    } else if (std::rand() % i < n) {
      sample[std::rand() % n] = item;
    }
    return sample;
  }
};

int main() {
  std::srand(std::time(NULL));
  int bin[10] = {0};
  for (int trial = 0; trial < 100000; trial++) {
    SOfN<int> s_of_n(3);
    std::vector<int> sample;
    for (int i = 0; i < 10; i++)
      sample = s_of_n(i);
    for (std::vector<int>::const_iterator i = sample.begin(); i != sample.end(); i++)
      bin[*i]++;
  }
  for (int i = 0; i < 10; i++)
    std::cout << bin[i] << std::endl;
  return 0;
}
