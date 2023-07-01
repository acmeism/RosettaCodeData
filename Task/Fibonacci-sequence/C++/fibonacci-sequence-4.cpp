#include <numeric>
#include <vector>
#include <functional>
#include <iostream>

unsigned int fibonacci(unsigned int n) {
  if (n == 0) return 0;
  std::vector<int> v(n, 1);
  adjacent_difference(v.begin(), v.end()-1, v.begin()+1, std::plus<int>());
  // "array" now contains the Fibonacci sequence from 1 up
  return v[n-1];
}
