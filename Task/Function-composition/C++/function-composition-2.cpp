#include <iostream>
#include <functional>
#include <cmath>

template <typename A, typename B, typename C>
std::function<C(A)> compose(std::function<C(B)> f, std::function<B(A)> g) {
  return [f,g](A x) { return f(g(x)); };
}

int main() {
  std::function<double(double)> f = sin;
  std::function<double(double)> g = asin;
  std::cout << compose(f, g)(0.5) << std::endl;
}
