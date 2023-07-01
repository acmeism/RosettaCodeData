#include <iostream>
#include <cstdint>
#include "prime_sieve.hpp"

typedef uint32_t integer;

// return number of decimal digits
int count_digits(integer n) {
    int digits = 0;
    for (; n > 0; ++digits)
        n /= 10;
    return digits;
}

// return the number with one digit replaced
integer change_digit(integer n, int index, int new_digit) {
    integer p = 1;
    integer changed = 0;
    for (; index > 0; p *= 10, n /= 10, --index)
        changed += p * (n % 10);
    changed += (10 * (n/10) + new_digit) * p;
    return changed;
}

// returns true if n unprimeable
bool unprimeable(const prime_sieve& sieve, integer n) {
    if (sieve.is_prime(n))
        return false;
    int d = count_digits(n);
    for (int i = 0; i < d; ++i) {
        for (int j = 0; j <= 9; ++j) {
            integer m = change_digit(n, i, j);
            if (m != n && sieve.is_prime(m))
                return false;
        }
    }
    return true;
}

int main() {
    const integer limit = 10000000;
    prime_sieve sieve(limit);

    // print numbers with commas
    std::cout.imbue(std::locale(""));

    std::cout << "First 35 unprimeable numbers:\n";
    integer n = 100;
    integer lowest[10] = { 0 };
    for (int count = 0, found = 0; n < limit && (found < 10 || count < 600); ++n) {
        if (unprimeable(sieve, n)) {
            if (count < 35) {
                if (count != 0)
                    std::cout << ", ";
                std::cout << n;
            }
            ++count;
            if (count == 600)
                std::cout << "\n600th unprimeable number: " << n << '\n';
            int last_digit = n % 10;
            if (lowest[last_digit] == 0) {
                lowest[last_digit] = n;
                ++found;
            }
        }
    }
    for (int i = 0; i < 10; ++i)
        std::cout << "Least unprimeable number ending in " << i << ": " << lowest[i] << '\n';
    return 0;
}
