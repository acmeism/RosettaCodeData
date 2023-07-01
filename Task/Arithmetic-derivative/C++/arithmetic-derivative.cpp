#include <iomanip>
#include <iostream>

#include <boost/multiprecision/cpp_int.hpp>

template <typename IntegerType>
IntegerType arithmetic_derivative(IntegerType n) {
    bool negative = n < 0;
    if (negative)
        n = -n;
    if (n < 2)
        return 0;
    IntegerType sum = 0, count = 0, m = n;
    while ((m & 1) == 0) {
        m >>= 1;
        count += n;
    }
    if (count > 0)
        sum += count / 2;
    for (IntegerType p = 3, sq = 9; sq <= m; p += 2) {
        count = 0;
        while (m % p == 0) {
            m /= p;
            count += n;
        }
        if (count > 0)
            sum += count / p;
        sq += (p + 1) << 2;
    }
    if (m > 1)
        sum += n / m;
    if (negative)
        sum = -sum;
    return sum;
}

int main() {
    using boost::multiprecision::int128_t;

    for (int n = -99, i = 0; n <= 100; ++n, ++i) {
        std::cout << std::setw(4) << arithmetic_derivative(n)
                  << ((i + 1) % 10 == 0 ? '\n' : ' ');
    }

    int128_t p = 10;
    std::cout << '\n';
    for (int i = 0; i < 20; ++i, p *= 10) {
        std::cout << "D(10^" << std::setw(2) << i + 1
                  << ") / 7 = " << arithmetic_derivative(p) / 7 << '\n';
    }
}
