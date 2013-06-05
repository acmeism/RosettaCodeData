#include <vector>
#include <iostream>

int main() {
  std::vector<int> a {1, 2, 3, 4};
  std::vector<int> b {5, 6, 7, 8, 9};

  a.insert(a.end(), b.begin(), b.end());

  for(int& i: a) std::cout << i << " ";
  std::cout << std::endl;
  return 0;
}
