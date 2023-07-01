#include <numeric>
#include <vector>
#include "boost/lambda/lambda.hpp"

double vec_add_squares(std::vector<double>& v)
{
  using namespace boost::lambda;

  return std::accumulate(v.begin(), v.end(), 0.0, _1 + _2 * _2);
}
