#include <iostream>

bool isPrime(uint64_t n) {
    if (n < 2) return false;
    if (n % 2 == 0) return n == 2;
    if (n % 3 == 0) return n == 3;

    uint64_t test = 5;
    while (test * test < n) {
        if (n % test == 0) return false;
        test += 2;
        if (n % test == 0) return false;
        test += 4;
    }

    return true;
}

int main() {
    uint64_t base = 2;

    for (int pow = 1; pow <= 32; pow++) {
        if (isPrime(base - 1)) {
            std::cout << "2 ^ " << pow << " - 1\n";
        }
        base *= 2;
    }

    return 0;
}
