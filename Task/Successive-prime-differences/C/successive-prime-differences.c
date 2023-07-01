#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#define PRIME_COUNT 100000
int64_t PRIMES[PRIME_COUNT];
size_t primeSize = 0;

bool isPrime(int n) {
    size_t i = 0;

    for (i = 0; i < primeSize; i++) {
        int64_t p = PRIMES[i];
        if (n == p) {
            return true;
        }
        if (n % p == 0) {
            return false;
        }
        if (p * p > n) {
            break;
        }
    }

    return true;
}

void initialize() {
    int i;

    PRIMES[primeSize++] = 2;
    PRIMES[primeSize++] = 3;
    PRIMES[primeSize++] = 5;
    PRIMES[primeSize++] = 7;
    PRIMES[primeSize++] = 11;
    PRIMES[primeSize++] = 13;
    PRIMES[primeSize++] = 17;
    PRIMES[primeSize++] = 19;

    for (i = 21; primeSize < PRIME_COUNT;) {
        if (isPrime(i)) {
            PRIMES[primeSize++] = i;
        }
        i += 2;

        if (primeSize < PRIME_COUNT && isPrime(i)) {
            PRIMES[primeSize++] = i;
        }
        i += 2;
    }
}

void diff1(size_t diff) {
    int64_t pm0, pm1;
    int64_t fg1 = 0, fg2 = 0, lg1 = 0, lg2 = 0;
    size_t pos, count = 0;

    if (diff == 0) {
        return;
    }

    pm0 = PRIMES[0];
    for (pos = 1; pos < PRIME_COUNT; pos++) {
        pm1 = pm0;
        pm0 = PRIMES[pos];
        if (pm0 > 1000000) {
            break;
        }
        if (pm0 - pm1 == diff) {
            count++;
            if (fg1 == 0) {
                fg1 = pm1;
                fg2 = pm0;
            }
            lg1 = pm1;
            lg2 = pm0;
        }
    }

    printf("%ld|%d|%lld %lld|%lld %lld|\n", diff, count, fg1, fg2, lg1, lg2);
}

void diff2(size_t d0, size_t d1) {
    int64_t pm0, pm1, pm2;
    int64_t fg1 = 0, fg2, fg3, lg1, lg2, lg3;
    size_t pos, count = 0;

    if (d0 == 0 || d1 == 0) {
        return;
    }

    pm1 = PRIMES[0];
    pm0 = PRIMES[1];
    for (pos = 2; pos < PRIME_COUNT; pos++) {
        pm2 = pm1;
        pm1 = pm0;
        pm0 = PRIMES[pos];
        if (pm0 > 1000000) {
            break;
        }
        if (pm1 - pm2 == d0 && pm0 - pm1 == d1) {
            count++;
            if (fg1 == 0) {
                fg1 = pm2;
                fg2 = pm1;
                fg3 = pm0;
            }
            lg1 = pm2;
            lg2 = pm1;
            lg3 = pm0;
        }
    }

    printf("%d %d|%d|%lld %lld %lld|%lld %lld %lld|\n", d0, d1, count, fg1, fg2, fg3, lg1, lg2, lg3);
}

void diff3(size_t d0, size_t d1, size_t d2) {
    int64_t pm0, pm1, pm2, pm3;
    int64_t fg1 = 0, fg2, fg3, fg4, lg1, lg2, lg3, lg4;
    size_t pos, count = 0;

    if (d0 == 0 || d1 == 0 || d2 == 0) {
        return;
    }

    pm2 = PRIMES[0];
    pm1 = PRIMES[1];
    pm0 = PRIMES[2];
    for (pos = 3; pos < PRIME_COUNT; pos++) {
        pm3 = pm2;
        pm2 = pm1;
        pm1 = pm0;
        pm0 = PRIMES[pos];
        if (pm0 > 1000000) {
            break;
        }
        if (pm2 - pm3 == d0 && pm1 - pm2 == d1 && pm0 - pm1 == d2) {
            count++;
            if (fg1 == 0) {
                fg1 = pm3;
                fg2 = pm2;
                fg3 = pm1;
                fg4 = pm0;
            }
            lg1 = pm3;
            lg2 = pm2;
            lg3 = pm1;
            lg4 = pm0;
        }
    }

    printf("%d %d %d|%d|%lld %lld %lld %lld|%lld %lld %lld %lld|\n", d0, d1, d2, count, fg1, fg2, fg3, fg4, lg1, lg2, lg3, lg4);
}

int main() {
    initialize();

    printf("differences|count|first group|last group\n");

    diff1(2);
    diff1(1);

    diff2(2, 2);
    diff2(2, 4);
    diff2(4, 2);

    diff3(6, 4, 2);

    return 0;
}
