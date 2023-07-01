#include <iostream>
#include <functional>
int main () {
  auto y = ([] (auto f) { return
              ([] (auto x) { return x (x); }
                 ([=] (auto y) -> std:: function <int (int)> { return
                    f ([=] (auto a) { return
                          (y (y)) (a) ;});}));});

  auto almost_fib = [] (auto f) { return
                       [=] (auto n) { return
                         n < 2? 1: f (n - 1) + f (n - 2) ;};};
  auto almost_fac = [] (auto f) { return
                       [=] (auto n) { return
                         n <= 1? n: n * f (n - 1); };};

  auto fib = y (almost_fib);
  auto fac = y (almost_fac);
  std:: cout << fib (10) << '\n'
             << fac (10) << '\n';
}
