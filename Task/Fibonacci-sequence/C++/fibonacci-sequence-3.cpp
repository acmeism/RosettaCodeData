#include <algorithm>
#include <vector>
#include <functional>
#include <iostream>

unsigned int fibonacci(unsigned int n) {
  if (n == 0) return 0;
  std::vector<int> v(n+1);
  v[1] = 1;
  transform(v.begin(), v.end()-2, v.begin()+1, v.begin()+2, std::plus<int>());
  // "v" now contains the Fibonacci sequence from 0 up
  return v[n];
}
