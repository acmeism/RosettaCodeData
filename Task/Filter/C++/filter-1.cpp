#include <vector>
#include <algorithm>
#include <functional>
#include <iterator>
#include <iostream>

int main() {
  std::vector<int> ary;
  for (int i = 0; i < 10; i++)
    ary.push_back(i);
  std::vector<int> evens;
  std::remove_copy_if(ary.begin(), ary.end(), back_inserter(evens),
                      std::bind2nd(std::modulus<int>(), 2)); // filter copy
  std::copy(evens.begin(), evens.end(),
            std::ostream_iterator<int>(std::cout, "\n"));

  return 0;
}
