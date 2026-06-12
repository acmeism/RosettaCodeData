#include <algorithm>
#include <iomanip>
#include <iostream>
#include <string>

#include <gmpxx.h>

using big_int = mpz_class;

bool is_probably_prime(const big_int& n) {
    return mpz_probab_prime_p(n.get_mpz_t(), 15) != 0;
}

big_int reverse(const big_int& n) {
    auto str = n.get_str();
    std::reverse(str.begin(), str.end());
    return big_int(str, 10);
}

std::string to_string(const big_int& num, size_t max_digits) {
    std::string str = num.get_str();
    size_t len = str.size();
    if (len > max_digits) {
        str.replace(max_digits / 2, len - max_digits, "...");
        str += " (";
        str += std::to_string(len);
        str += " digits)";
    }
    return str;
}

int main() {
    big_int f0 = 0, f1 = 1;
    std::cout << "First 30 Iccanobif primes:\n";
    for (int count = 0; count < 30;) {
        big_int f = f0 + f1;
        auto p = reverse(f);
        if (is_probably_prime(p)) {
            ++count;
            std::cout << std::setw(2) << count << ": " << to_string(p, 40)
                      << '\n';
        }
        f0 = f1;
        f1 = f;
    }
}
