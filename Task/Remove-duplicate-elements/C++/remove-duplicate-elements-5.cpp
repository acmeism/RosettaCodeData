#include <algorithm>
#include <iostream>
#include <vector>

int main() {
  std::vector<int> data = {1, 2, 3, 2, 3, 4};

  std::sort(data.begin(), data.end());
  data.erase(std::unique(data.begin(), data.end()), data.end());

  for(int& i: data) std::cout << i << " ";
  std::cout << std::endl;
  return 0;
}
