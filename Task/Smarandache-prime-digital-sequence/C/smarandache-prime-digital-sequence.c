#include <locale.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

typedef uint32_t integer;

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
    static const integer wheel[] = { 4,2,4,2,4,6,2,6 };
    integer p = 7;
    for (;;) {
        for (int i = 0; i < 8; ++i) {
            if (p * p > n)
                return true;
            if (n % p == 0)
                return false;
            p += wheel[i];
        }
    }
}

int main() {
    setlocale(LC_ALL, "");
    const integer limit = 1000000000;
    integer n = 0, max = 0;
    printf("First 25 SPDS primes:\n");
    for (int i = 0; n < limit; ) {
        n = next_prime_digit_number(n);
        if (!is_prime(n))
            continue;
        if (i < 25) {
            if (i > 0)
                printf(" ");
            printf("%'u", n);
        }
        else if (i == 25)
            printf("\n");
        ++i;
        if (i == 100)
            printf("Hundredth SPDS prime: %'u\n", n);
        else if (i == 1000)
            printf("Thousandth SPDS prime: %'u\n", n);
        else if (i == 10000)
            printf("Ten thousandth SPDS prime: %'u\n", n);
        max = n;
    }
    printf("Largest SPDS prime less than %'u: %'u\n", limit, max);
    return 0;
}
