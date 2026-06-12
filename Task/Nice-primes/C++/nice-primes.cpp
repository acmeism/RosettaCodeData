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

unsigned int digital_root(unsigned int n) {
    return n == 0 ? 0 : 1 + (n - 1) % 9;
}

int main() {
    const unsigned int from = 500, to = 1000;
    std::cout << "Nice primes between " << from << " and " << to << ":\n";
    unsigned int count = 0;
    for (unsigned int n = from; n < to; ++n) {
        if (is_prime(digital_root(n)) && is_prime(n)) {
            ++count;
            std::cout << n << (count % 10 == 0 ? '\n' : ' ');
        }
    }
    std::cout << '\n' << count << " nice primes found.\n";
}
