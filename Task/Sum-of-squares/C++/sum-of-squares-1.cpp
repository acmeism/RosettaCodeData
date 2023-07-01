#include <iostream>
#include <numeric>
#include <vector>

double add_square(double prev_sum, double new_val)
{
  return prev_sum + new_val*new_val;
}

double vec_add_squares(std::vector<double>& v)
{
  return std::accumulate(v.begin(), v.end(), 0.0, add_square);
}

int main()
{
  // first, show that for empty vectors we indeed get 0
  std::vector<double> v; // empty
  std::cout << vec_add_squares(v) << std::endl;

  // now, use some values
  double data[] = { 0, 1, 3, 1.5, 42, 0.1, -4 };
  v.assign(data, data+7);
  std::cout << vec_add_squares(v) << std::endl;
  return 0;
}
