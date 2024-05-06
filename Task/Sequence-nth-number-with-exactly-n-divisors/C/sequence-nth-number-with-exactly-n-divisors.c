#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#define LIMIT 15
int smallPrimes[LIMIT];

static void sieve() {
    int i = 2, j;
    int p = 5;

    smallPrimes[0] = 2;
    smallPrimes[1] = 3;

    while (i < LIMIT) {
        for (j = 0; j < i; j++) {
            if (smallPrimes[j] * smallPrimes[j] <= p) {
                if (p % smallPrimes[j] == 0) {
                    p += 2;
                    break;
                }
            } else {
                smallPrimes[i++] = p;
                p += 2;
                break;
            }
        }
    }
}

static bool is_prime(uint64_t n) {
    uint64_t i;

    for (i = 0; i < LIMIT; i++) {
        if (n % smallPrimes[i] == 0) {
            return n == smallPrimes[i];
        }
    }

    i = smallPrimes[LIMIT - 1] + 2;
    for (; i * i <= n; i += 2) {
        if (n % i == 0) {
            return false;
        }
    }

    return true;
}

static uint64_t divisor_count(uint64_t n) {
    uint64_t count = 1;
    uint64_t d;

    while (n % 2 == 0) {
        n /= 2;
        count++;
    }

    for (d = 3; d * d <= n; d += 2) {
        uint64_t q = n / d;
        uint64_t r = n % d;
        uint64_t dc = 0;
        while (r == 0) {
            dc += count;
            n = q;
            q = n / d;
            r = n % d;
        }
        count += dc;
    }

    if (n != 1) {
        return count *= 2;
    }
    return count;
}

static uint64_t OEISA073916(size_t n) {
    uint64_t count = 0;
    uint64_t result = 0;
    size_t i;

    if (is_prime(n)) {
        return (uint64_t)pow(smallPrimes[n - 1], n - 1);
    }

    for (i = 1; count < n; i++) {
        if (n % 2 == 1) {
            //  The solution for an odd (non-prime) term is always a square number
            uint64_t root = (uint64_t)sqrt(i);
            if (root * root != i) {
                continue;
            }
        }
        if (divisor_count(i) == n) {
            count++;
            result = i;
        }
    }

    return result;
}

int main() {
    size_t n;

    sieve();

    for (n = 1; n <= LIMIT; n++) {
        if (n == 13) {
            printf("A073916(%lu) = One more bit needed to represent result.\n", n);
        } else {
            printf("A073916(%lu) = %llu\n", n, OEISA073916(n));
        }
    }

    return 0;
}
