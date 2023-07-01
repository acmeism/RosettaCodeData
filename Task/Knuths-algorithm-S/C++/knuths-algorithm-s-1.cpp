#include <iostream>
#include <functional>
#include <vector>
#include <cstdlib>
#include <ctime>

template <typename T>
std::function<std::vector<T>(T)> s_of_n_creator(int n) {
  std::vector<T> sample;
  int i = 0;
  return [=](T item) mutable {
    i++;
    if (i <= n) {
      sample.push_back(item);
    } else if (std::rand() % i < n) {
      sample[std::rand() % n] = item;
    }
    return sample;
  };
}

int main() {
  std::srand(std::time(NULL));
  int bin[10] = {0};
  for (int trial = 0; trial < 100000; trial++) {
    auto s_of_n = s_of_n_creator<int>(3);
    std::vector<int> sample;
    for (int i = 0; i < 10; i++)
      sample = s_of_n(i);
    for (int s : sample)
      bin[s]++;
  }
  for (int x : bin)
    std::cout << x << std::endl;
  return 0;
}
