#include <boost/iterator/counting_iterator.hpp>
#include <algorithm>

int factorial(int n)
{
  // last is one-past-end
  return std::accumulate(boost::counting_iterator<int>(1), boost::counting_iterator<int>(n+1), 1, std::multiplies<int>());
}
