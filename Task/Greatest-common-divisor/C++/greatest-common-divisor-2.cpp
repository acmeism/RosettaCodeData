#include <boost/math/common_factor.hpp>
#include <iostream>

int main() {
   std::cout << "The greatest common divisor of 12 and 18 is " << boost::math::gcd(12, 18) << "!\n";
}
