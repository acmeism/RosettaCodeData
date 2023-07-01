#include <iostream>
#include <complex>

int main() {
  std::cout << std::exp(std::complex<double>(0.0, M_PI)) + 1.0 << std::endl;
  return 0;
}
