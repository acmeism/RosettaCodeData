#include <iomanip>
#include <iostream>

#include <gmpxx.h>

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
    big_int f = 1;
    for (int i = 0, n = 1; i < 31; ++n) {
        f *= n;
        if (is_probably_prime(f - 1)) {
            ++i;
            std::cout << std::setw(2) << i << ": " << std::setw(3) << n
                      << "! - 1 = " << to_string(f - 1, 40) << '\n';
        }
        if (is_probably_prime(f + 1)) {
            ++i;
            std::cout << std::setw(2) << i << ": " << std::setw(3) << n
                      << "! + 1 = " << to_string(f + 1, 40) << '\n';
        }
    }
}
