#include <iostream>

unsigned int ackermann(unsigned int m, unsigned int n) {
  if (m == 0) {
    return n + 1;
  }
  if (n == 0) {
    return ackermann(m - 1, 1);
  }
  return ackermann(m - 1, ackermann(m, n - 1));
}

int main() {
  for (unsigned int m = 0; m < 4; ++m) {
    for (unsigned int n = 0; n < 10; ++n) {
      std::cout << "A(" << m << ", " << n << ") = " << ackermann(m, n) << "\n";
    }
  }
}
