#include <boost/multiprecision/cpp_dec_float.hpp>
#include <boost/multiprecision/gmp.hpp>
#include <iomanip>
#include <iostream>

namespace mp = boost::multiprecision;
using big_int = mp::mpz_int;
using big_float = mp::cpp_dec_float_100;
using rational = mp::mpq_rational;

big_int factorial(int n) {
    big_int result = 1;
    for (int i = 2; i <= n; ++i)
        result *= i;
    return result;
}

// Return the integer portion of the nth term of Almkvist-Giullera sequence.
big_int almkvist_giullera(int n) {
    return factorial(6 * n) * 32 * (532 * n * n + 126 * n + 9) /
           (pow(factorial(n), 6) * 3);
}

int main() {
    std::cout << "n |                  Integer portion of nth term\n"
              << "------------------------------------------------\n";
    for (int n = 0; n < 10; ++n)
        std::cout << n << " | " << std::setw(44) << almkvist_giullera(n)
                  << '\n';

    big_float epsilon(pow(big_float(10), -70));
    big_float prev = 0, pi = 0;
    rational sum = 0;
    for (int n = 0;; ++n) {
        rational term(almkvist_giullera(n), pow(big_int(10), 6 * n + 3));
        sum += term;
        pi = sqrt(big_float(1 / sum));
        if (abs(pi - prev) < epsilon)
            break;
        prev = pi;
    }
    std::cout << "\nPi to 70 decimal places is:\n"
              << std::fixed << std::setprecision(70) << pi << '\n';
}
