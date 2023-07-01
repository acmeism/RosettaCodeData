#include <iostream>
#include <bitset>
#include <climits>

size_t popcount(unsigned long long n) {
  return std::bitset<CHAR_BIT * sizeof n>(n).count();
}

int main() {
  {
    unsigned long long n = 1;
    for (int i = 0; i < 30; i++) {
      std::cout << popcount(n) << " ";
      n *= 3;
    }
    std::cout << std::endl;
  }

  int od[30];
  int ne = 0, no = 0;
  std::cout << "evil  : ";
  for (int n = 0; ne+no < 60; n++) {
    if ((popcount(n) & 1) == 0) {
      if (ne < 30) {
	std::cout << n << " ";
	ne++;
      }
    } else {
      if (no < 30) {
	od[no++] = n;
      }
    }
  }
  std::cout << std::endl;
  std::cout << "odious: ";
  for (int i = 0; i < 30; i++) {
    std::cout << od[i] << " ";
  }
  std::cout << std::endl;

  return 0;
}
