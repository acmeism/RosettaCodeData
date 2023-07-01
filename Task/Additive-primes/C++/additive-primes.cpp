#include <iomanip>
#include <iostream>

bool is_prime(unsigned int n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    for (unsigned int p = 5; p * p <= n; p += 4) {
        if (n % p == 0)
            return false;
        p += 2;
        if (n % p == 0)
            return false;
    }
    return true;
}

unsigned int digit_sum(unsigned int n) {
    unsigned int sum = 0;
    for (; n > 0; n /= 10)
        sum += n % 10;
    return sum;
}

int main() {
    const unsigned int limit = 500;
    std::cout << "Additive primes less than " << limit << ":\n";
    unsigned int count = 0;
    for (unsigned int n = 1; n < limit; ++n) {
        if (is_prime(digit_sum(n)) && is_prime(n)) {
            std::cout << std::setw(3) << n;
            if (++count % 10 == 0)
                std::cout << '\n';
            else
                std::cout << ' ';
        }
    }
    std::cout << '\n' << count << " additive primes found.\n";
}
