#include <iostream>
#include <cmath>
#include <ext/functional>

int main() {
  std::cout << __gnu_cxx::compose1(std::ptr_fun(::sin), std::ptr_fun(::asin))(0.5) << std::endl;

  return 0;
}
