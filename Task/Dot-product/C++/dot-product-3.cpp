#include <iostream>
#include <vector>
#include <numeric>

int main() {
  std::vector<int> v1 { 1,  3, -5, };
  std::vector<int> v2 { 4, -2, -1, };
  auto dp = std::inner_product(v1.cbegin(), v1.cend(), v2.cbegin(), 0);
  std::cout << "dot.product of {1,3,-5} and {4,-2,-1}: " << dp << std::endl;
  return 0;
}
