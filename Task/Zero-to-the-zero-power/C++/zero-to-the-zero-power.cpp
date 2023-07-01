#include <iostream>
#include <cmath>
#include <complex>

int main()
{
  std::cout << "0 ^ 0 = " << std::pow(0,0) << std::endl;
  std::cout << "0+0i ^ 0+0i = " <<
    std::pow(std::complex<double>(0),std::complex<double>(0)) << std::endl;
  return 0;
}
