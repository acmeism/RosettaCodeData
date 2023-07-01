#include <iostream>
#include <boost/multiprecision/cpp_int.hpp>

template <typename T> T sum_multiples(T n, T m) {
    n -= T(1);
    n -= n % m;
    return (n / m) * (m + n) / T(2);
}

template <typename T> T sum35(T n) {
    return sum_multiples(n, T(3)) + sum_multiples(n, T(5)) -
           sum_multiples(n, T(15));
}

int main() {
    using big_int = boost::multiprecision::cpp_int;

    std::cout << sum35(1000) << '\n';
    std::cout << sum35(big_int("100000000000000000000")) << '\n';
}
