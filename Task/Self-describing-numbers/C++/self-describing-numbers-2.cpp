#include <algorithm>
#include <array>
#include <iostream>

bool is_self_describing(unsigned long long int n) noexcept {
  if (n == 0) {
    return false;
  }

  std::array<char, 10> digits = {0}, counts = {0};
  std::size_t i = digits.size();

  do {
    counts[digits[--i] = n % 10]++;
  } while ((n /= 10) > 0 && i < digits.size());

  return n == 0 && std::equal(begin(digits) + i, end(digits), begin(counts));
}

int main() {
  for (unsigned long long int i = 0; i < 10000000000; ++i) {
    if (is_self_describing(i)) {
      std::cout << i << "\n";
    }
  }
}
