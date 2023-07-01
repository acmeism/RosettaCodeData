#include <iomanip>
#include <iostream>
#include <sstream>
#include <boost/multiprecision/cpp_int.hpp>

using big_int = boost::multiprecision::cpp_int;

template <typename integer>
integer isqrt(integer x) {
    integer q = 1;
    while (q <= x)
        q <<= 2;
    integer r = 0;
    while (q > 1) {
        q >>= 2;
        integer t = x - r - q;
        r >>= 1;
        if (t >= 0) {
            x = t;
            r += q;
        }
    }
    return r;
}

std::string commatize(const big_int& n) {
    std::ostringstream out;
    out << n;
    std::string str(out.str());
    std::string result;
    size_t digits = str.size();
    result.reserve(4 * digits/3);
    for (size_t i = 0; i < digits; ++i) {
        if (i > 0 && i % 3 == digits % 3)
            result += ',';
        result += str[i];
    }
    return result;
}

int main() {
    std::cout << "Integer square root for numbers 0 to 65:\n";
    for (int n = 0; n <= 65; ++n)
        std::cout << isqrt(n) << ' ';
    std::cout << "\n\n";

    std::cout << "Integer square roots of odd powers of 7 from 1 to 73:\n";
    const int power_width = 83, isqrt_width = 42;
    std::cout << " n |"
        << std::setw(power_width) << "7 ^ n" << " |"
        << std::setw(isqrt_width) << "isqrt(7 ^ n)"
        << '\n';
    std::cout << std::string(6 + power_width + isqrt_width, '-') << '\n';
    big_int p = 7;
    for (int n = 1; n <= 73; n += 2, p *= 49) {
        std::cout << std::setw(2) << n << " |"
            << std::setw(power_width) << commatize(p) << " |"
            << std::setw(isqrt_width) << commatize(isqrt(p))
            << '\n';
    }
    return 0;
}
