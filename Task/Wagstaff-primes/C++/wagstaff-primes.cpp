#include <gmpxx.h>
#include <primesieve.hpp>

#include <iostream>

using big_int = mpz_class;

std::string to_string(const big_int& num, size_t n) {
    std::string str = num.get_str();
    size_t len = str.size();
    if (len > n) {
        str = str.substr(0, n / 2) + "..." + str.substr(len - n / 2);
        str += " (";
        str += std::to_string(len);
        str += " digits)";
    }
    return str;
}

bool is_probably_prime(const big_int& n) {
    return mpz_probab_prime_p(n.get_mpz_t(), 25) != 0;
}

int main() {
    const big_int one(1);
    primesieve::iterator pi;
    pi.next_prime();
    for (int i = 0; i < 24;) {
        uint64_t p = pi.next_prime();
        big_int n = ((one << p) + 1) / 3;
        if (is_probably_prime(n))
            std::cout << ++i << ": " << p << " - " << to_string(n, 30) << '\n';
    }
}
