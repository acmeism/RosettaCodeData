#include <iomanip>
#include <iostream>
#include <boost/math/constants/constants.hpp>
#include <boost/multiprecision/cpp_dec_float.hpp>

using big_float = boost::multiprecision::cpp_dec_float_100;

big_float f(unsigned int n) {
    big_float pi(boost::math::constants::pi<big_float>());
    return exp(sqrt(big_float(n)) * pi);
}

int main() {
    std::cout << "Ramanujan's constant using formula f(N) = exp(pi*sqrt(N)):\n"
        << std::setprecision(80) << f(163) << '\n';
    std::cout << "\nResult with last four Heegner numbers:\n";
    std::cout << std::setprecision(30);
    for (unsigned int n : {19, 43, 67, 163}) {
        auto x = f(n);
        auto c = ceil(x);
        auto pc = 100.0 * (x/c);
        std::cout << "f(" << n << ") = " << x << " = "
            << pc << "% of " << c << '\n';
    }
    return 0;
}
