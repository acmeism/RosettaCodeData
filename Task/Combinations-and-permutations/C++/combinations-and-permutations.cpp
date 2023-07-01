#include <boost/multiprecision/gmp.hpp>
#include <iostream>

using namespace boost::multiprecision;

mpz_int p(uint n, uint p) {
    mpz_int r = 1;
    mpz_int k = n - p;
    while (n > k)
        r *= n--;
    return r;
}

mpz_int c(uint n, uint k) {
    mpz_int r = p(n, k);
    while (k)
        r /= k--;
    return r;
}

int main() {
    for (uint i = 1u; i < 12u; i++)
        std::cout << "P(12," << i << ") = " << p(12u, i) << std::endl;
    for (uint i = 10u; i < 60u; i += 10u)
        std::cout << "C(60," << i << ") = " << c(60u, i) << std::endl;

    return 0;
}
