#include <iostream>
#include <cstdint>

using integer = uint32_t;

integer next_prime_digit_number(integer n) {
    if (n == 0)
        return 2;
    switch (n % 10) {
    case 2:
        return n + 1;
    case 3:
    case 5:
        return n + 2;
    default:
        return 2 + next_prime_digit_number(n/10) * 10;
    }
}

bool is_prime(integer n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    if (n % 5 == 0)
        return n == 5;
    constexpr integer wheel[] = { 4,2,4,2,4,6,2,6 };
    integer p = 7;
    for (;;) {
        for (integer w : wheel) {
            if (p * p > n)
                return true;
            if (n % p == 0)
                return false;
            p += w;
        }
    }
}

int main() {
    std::cout.imbue(std::locale(""));
    const integer limit = 1000000000;
    integer n = 0, max = 0;
    std::cout << "First 25 SPDS primes:\n";
    for (int i = 0; n < limit; ) {
        n = next_prime_digit_number(n);
        if (!is_prime(n))
            continue;
        if (i < 25) {
            if (i > 0)
                std::cout << ' ';
            std::cout << n;
        }
        else if (i == 25)
            std::cout << '\n';
        ++i;
        if (i == 100)
            std::cout << "Hundredth SPDS prime: " << n << '\n';
        else if (i == 1000)
            std::cout << "Thousandth SPDS prime: " << n << '\n';
        else if (i == 10000)
            std::cout << "Ten thousandth SPDS prime: " << n << '\n';
        max = n;
    }
    std::cout << "Largest SPDS prime less than " << limit << ": " << max << '\n';
    return 0;
}
