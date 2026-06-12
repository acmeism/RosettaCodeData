#include <iomanip>
#include <iostream>

unsigned int next_prime_digit_number(unsigned int n) {
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

bool is_prime(unsigned int n) {
    if (n < 2)
        return false;
    if ((n & 1) == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    if (n % 5 == 0)
        return n == 5;
    static constexpr unsigned int wheel[] = { 4,2,4,2,4,6,2,6 };
    unsigned int p = 7;
    for (;;) {
        for (unsigned int w : wheel) {
            if (p * p > n)
                return true;
            if (n % p == 0)
                return false;
            p += w;
        }
    }
}

unsigned int digit_sum(unsigned int n) {
    unsigned int sum = 0;
    for (; n > 0; n /= 10)
        sum += n % 10;
    return sum;
}

int main() {
    std::cout.imbue(std::locale(""));
    const unsigned int limit1 = 10000;
    const unsigned int limit2 = 1000000000;
    const int last = 10;
    unsigned int p = 0, n = 0;
    unsigned int extra_primes[last];
    std::cout << "Extra primes under " << limit1 << ":\n";
    while ((p = next_prime_digit_number(p)) < limit2) {
        if (is_prime(digit_sum(p)) && is_prime(p)) {
            ++n;
            if (p < limit1)
                std::cout << std::setw(2) << n << ": " << p << '\n';
            extra_primes[n % last] = p;
        }
    }
    std::cout << "\nLast " << last << " extra primes under " << limit2 << ":\n";
    for (int i = last - 1; i >= 0; --i)
        std::cout << n-i << ": " << extra_primes[(n-i) % last] << '\n';
    return 0;
}
