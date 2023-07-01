#include <iostream>
#include <gmpxx.h>

using big_int = mpz_class;

int main() {
    for (unsigned int d = 2; d <= 9; ++d) {
        std::cout << "First 10 super-" << d << " numbers:\n";
        std::string digits(d, '0' + d);
        big_int bignum;
        for (unsigned int count = 0, n = 1; count < 10; ++n) {
            mpz_ui_pow_ui(bignum.get_mpz_t(), n, d);
            bignum *= d;
            auto str(bignum.get_str());
            if (str.find(digits) != std::string::npos) {
                std::cout << n << ' ';
                ++count;
            }
        }
        std::cout << '\n';
    }
    return 0;
}
