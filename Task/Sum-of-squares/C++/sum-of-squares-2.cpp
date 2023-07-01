#include <iostream>
#include <numeric>
#include <vector>

int main()
{
  // first, show that for empty vectors we indeed get 0
  std::vector<double> v; // empty
  std::cout << std::inner_product(begin(v), end(v), begin(v), 0.0) << std::endl;

  // now, use some values
  double data[] = { 0, 1, 3, 1.5, 42, 0.1, -4 };
  v.assign(data, data+7);
  std::cout << std::inner_product(begin(v), end(v), begin(v), 0.0) << std::endl;
  return 0;
}
