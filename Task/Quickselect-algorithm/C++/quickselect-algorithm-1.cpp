#include <algorithm>
#include <iostream>

int main() {
  for (int i = 0; i < 10; i++) {
    int a[] = {9, 8, 7, 6, 5, 0, 1, 2, 3, 4};
    std::nth_element(a, a + i, a + sizeof(a)/sizeof(*a));
    std::cout << a[i];
    if (i < 9) std::cout << ", ";
  }
  std::cout << std::endl;

  return 0;
}
