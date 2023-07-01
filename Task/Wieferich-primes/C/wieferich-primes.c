#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>

#define LIMIT 5000
static bool PRIMES[LIMIT];

static void prime_sieve() {
    uint64_t p;
    int i;

    PRIMES[0] = false;
    PRIMES[1] = false;
    for (i = 2; i < LIMIT; i++) {
        PRIMES[i] = true;
    }

    for (i = 4; i < LIMIT; i += 2) {
        PRIMES[i] = false;
    }

    for (p = 3;; p += 2) {
        uint64_t q = p * p;
        if (q >= LIMIT) {
            break;
        }
        if (PRIMES[p]) {
            uint64_t inc = 2 * p;
            for (; q < LIMIT; q += inc) {
                PRIMES[q] = false;
            }
        }
    }
}

uint64_t modpow(uint64_t base, uint64_t exp, uint64_t mod) {
    uint64_t result = 1;

    if (mod == 1) {
        return 0;
    }

    base %= mod;
    for (; exp > 0; exp >>= 1) {
        if ((exp & 1) == 1) {
            result = (result * base) % mod;
        }
        base = (base * base) % mod;
    }
    return result;
}

void wieferich_primes() {
    uint64_t p;

    for (p = 2; p < LIMIT; ++p) {
        if (PRIMES[p] && modpow(2, p - 1, p * p) == 1) {
            printf("%lld\n", p);
        }
    }
}

int main() {
    prime_sieve();

    printf("Wieferich primes less than %d:\n", LIMIT);
    wieferich_primes();

    return 0;
}
