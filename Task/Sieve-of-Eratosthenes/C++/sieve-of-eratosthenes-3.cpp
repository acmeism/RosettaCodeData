/**
   $ g++ -I/path/to/boost sieve.cpp -o sieve && sieve 10000000
 */
#include <inttypes.h> // uintmax_t
#include <limits>
#include <cmath>
#include <iostream>
#include <sstream>
#include <vector>

#include <boost/lambda/lambda.hpp>

int main(int argc, char *argv[])
{
  using namespace std;
  using namespace boost::lambda;

  int limit = 10000;
  if (argc == 2) {
    stringstream ss(argv[--argc]);
    ss >> limit;

    if (limit < 1 or ss.fail()) {
      cerr << "USAGE:\n  sieve LIMIT\n\nwhere LIMIT in the range [1, "
	   << numeric_limits<int>::max() << ")" << endl;
      return 2;
    }
  }

  // print primes less then 100
  primesupto(100, cout << _1 << " ");
  cout << endl;

  // find number of primes less then limit and their sum
  int count = 0;
  uintmax_t sum = 0;
  primesupto(limit, (var(sum) += _1, var(count) += 1));

  cout << "limit sum pi(n)\n"
       << limit << " " << sum << " " << count << endl;
}
