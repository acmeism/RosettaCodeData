#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gmp.h>

bool is_prime(uint32_t n) {
    if (n == 2)
        return true;
    if (n < 2 || n % 2 == 0)
        return false;
    for (uint32_t p = 3; p * p <= n; p += 2) {
        if (n % p == 0)
            return false;
    }
    return true;
}

// e.g. returns 2341 if n = 1234
uint32_t cycle(uint32_t n) {
    uint32_t m = n, p = 1;
    while (m >= 10) {
        p *= 10;
        m /= 10;
    }
    return m + 10 * (n % p);
}

bool is_circular_prime(uint32_t p) {
    if (!is_prime(p))
        return false;
    uint32_t p2 = cycle(p);
    while (p2 != p) {
        if (p2 < p || !is_prime(p2))
            return false;
        p2 = cycle(p2);
    }
    return true;
}

void test_repunit(uint32_t digits) {
    char* str = malloc(digits + 1);
    if (str == 0) {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    memset(str, '1', digits);
    str[digits] = 0;
    mpz_t bignum;
    mpz_init_set_str(bignum, str, 10);
    free(str);
    if (mpz_probab_prime_p(bignum, 10))
        printf("R(%u) is probably prime.\n", digits);
    else
        printf("R(%u) is not prime.\n", digits);
    mpz_clear(bignum);
}

int main() {
    uint32_t p = 2;
    printf("First 19 circular primes:\n");
    for (int count = 0; count < 19; ++p) {
        if (is_circular_prime(p)) {
            if (count > 0)
                printf(", ");
            printf("%u", p);
            ++count;
        }
    }
    printf("\n");
    printf("Next 4 circular primes:\n");
    uint32_t repunit = 1, digits = 1;
    for (; repunit < p; ++digits)
        repunit = 10 * repunit + 1;
    mpz_t bignum;
    mpz_init_set_ui(bignum, repunit);
    for (int count = 0; count < 4; ) {
        if (mpz_probab_prime_p(bignum, 15)) {
            if (count > 0)
                printf(", ");
            printf("R(%u)", digits);
            ++count;
        }
        ++digits;
        mpz_mul_ui(bignum, bignum, 10);
        mpz_add_ui(bignum, bignum, 1);
    }
    mpz_clear(bignum);
    printf("\n");
    test_repunit(5003);
    test_repunit(9887);
    test_repunit(15073);
    test_repunit(25031);
    test_repunit(35317);
    test_repunit(49081);
    return 0;
}
