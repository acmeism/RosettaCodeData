#include <iostream>
#include <vector>
#include <numeric>
#include <algorithm>

int topswops(int n) {
  std::vector<int> list(n);
  std::iota(std::begin(list), std::end(list), 1);
  int max_steps = 0;
  do {
    auto temp_list = list;
    for (int steps = 1; temp_list[0] != 1; ++steps) {
      std::reverse(std::begin(temp_list), std::begin(temp_list) + temp_list[0]);
      if (steps > max_steps) max_steps = steps;
    }
  } while (std::next_permutation(std::begin(list), std::end(list)));
  return max_steps;
}

int main() {
  for (int i = 1; i <= 10; ++i) {
    std::cout << i << ": " << topswops(i) << std::endl;
  }
  return 0;
}
