#include <gmpxx.h>

#include <algorithm>
#include <cassert>
#include <functional>
#include <iostream>
#include <vector>

using big_int = mpz_class;

const unsigned int small_primes[] = {2,  3,  5,  7,  11, 13, 17, 19, 23,
                                     29, 31, 37, 41, 43, 47, 53, 59, 61,
                                     67, 71, 73, 79, 83, 89, 97};

bool is_probably_prime(const big_int& n, int reps) {
    return mpz_probab_prime_p(n.get_mpz_t(), reps) != 0;
}

big_int largest_left_truncatable_prime(unsigned int base) {
    std::vector<big_int> powers = {1};
    std::vector<big_int> value = {0};
    big_int result = 0;

    std::function<void(unsigned int)> add_digit = [&](unsigned int i) {
        if (i == value.size()) {
            value.resize(i + 1);
            powers.push_back(base * powers.back());
        }
        for (unsigned int d = 1; d < base; ++d) {
            value[i] = value[i - 1] + powers[i] * d;
            if (!is_probably_prime(value[i], 1))
                continue;
            if (value[i] > result) {
                if (!is_probably_prime(value[i], 50))
                    continue;
                result = value[i];
            }
            add_digit(i + 1);
        }
    };

    for (unsigned int i = 0; small_primes[i] < base; ++i) {
        value[0] = small_primes[i];
        add_digit(1);
    }
    return result;
}

int main() {
    for (unsigned int base = 3; base < 18; ++base) {
        std::cout << base << ": " << largest_left_truncatable_prime(base)
                  << '\n';
    }
    for (unsigned int base = 19; base < 32; base += 2) {
        std::cout << base << ": " << largest_left_truncatable_prime(base)
                  << '\n';
    }
}
