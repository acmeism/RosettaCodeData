#include <iostream>
#include <cmath>

auto compose(auto f, auto g) {
     return [=](auto x) { return f(g(x)); };
}

int main() {
  std::cout << compose(sin, asin)(0.5) << "\n";
}
