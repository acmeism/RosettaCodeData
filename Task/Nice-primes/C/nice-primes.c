#include <stdbool.h>
#include <stdio.h>

bool is_prime(unsigned int n) {
    if (n < 2) {
        return false;
    }
    if (n % 2 == 0) {
        return n == 2;
    }
    if (n % 3 == 0) {
        return n == 3;
    }
    for (unsigned int p = 5; p * p <= n; p += 4) {
        if (n % p == 0) {
            return false;
        }
        p += 2;
        if (n % p == 0) {
            return false;
        }
    }
    return true;
}

unsigned int digital_root(unsigned int n) {
    return n == 0 ? 0 : 1 + (n - 1) % 9;
}

int main() {
    const unsigned int from = 500, to = 1000;
    unsigned int count = 0;
    unsigned int n;

    printf("Nice primes between %d and %d:\n", from, to);
    for (n = from; n < to; ++n) {
        if (is_prime(digital_root(n)) && is_prime(n)) {
            ++count;
            //std::cout << n << (count % 10 == 0 ? '\n' : ' ');
            printf("%d", n);
            if (count % 10 == 0) {
                putc('\n', stdout);
            } else {
                putc(' ', stdout);
            }
        }
    }
    printf("\n%d nice primes found.\n", count);

    return 0;
}
