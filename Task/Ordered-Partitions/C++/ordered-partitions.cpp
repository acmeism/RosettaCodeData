#include <iostream>
#include <algorithm>
#include <vector>
#include <numeric>

void partitions(std::vector<size_t> args) {
  size_t sum = std::accumulate(std::begin(args), std::end(args), 0);
  std::vector<size_t> nums(sum);
  std::iota(std::begin(nums), std::end(nums), 1);
  do {
    size_t total_index = 0;
    std::vector<std::vector<size_t>> parts;
    for (const auto& a : args) {
      std::vector<size_t> part;
      bool cont = true;
      for (size_t j = 0; j < a; ++j) {
        for (const auto& p : part) {
          if (nums[total_index] < p) {
            cont = false;
            break;
          }
        }
        if (cont) {
          part.push_back(nums[total_index]);
          ++total_index;
        }
      }
      if (part.size() != a) {
        break;
      }
      parts.push_back(part);
    }
    if (parts.size() == args.size()) {
      std::cout << "(";
      for (const auto& p : parts) {
        std::cout << "{ ";
        for (const auto& e : p) {
          std::cout << e << " ";
        }
        std::cout << "},";
      }
      std::cout << ")," << std::endl;
    }
  } while (std::next_permutation(std::begin(nums), std::end(nums)));
}

int main() {
  std::vector<size_t> args = { 2, 0, 2 };
  partitions(args);
  std::cin.ignore();
  std::cin.get();
  return 0;
}
