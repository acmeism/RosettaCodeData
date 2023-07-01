#include <iostream>
#include <iomanip>
#include <cmath>
#include <boost/math/constants/constants.hpp>

int main()
{
    using namespace boost::math::double_constants;
    std::cout << "e = " << std::setprecision(18) << e
              << "\ne³ = " << std::exp(3.0)
              << "\nπ = " << pi
              << "\nπ² = " << pi_sqr
              << "\n√2 = " << root_two
              << "\nln(e) = " << std::log(e)
              << "\nlg(100) = " << std::log10(100.0)
              << "\n|-4.5| = " << std::abs(-4.5)
              << "\nfloor(4.5) = " << std::floor(4.5)
              << "\nceiling(4.5) = " << std::ceil(4.5) << std::endl;
}
