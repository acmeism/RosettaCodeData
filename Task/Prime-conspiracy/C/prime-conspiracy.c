#include <assert.h>
#include <stdbool.h>
#include <stdio.h>

typedef unsigned char byte;

struct Transition {
    byte a, b;
    unsigned int c;
} transitions[100];

void init() {
    int i, j;
    for (i = 0; i < 10; i++) {
        for (j = 0; j < 10; j++) {
            int idx = i * 10 + j;
            transitions[idx].a = i;
            transitions[idx].b = j;
            transitions[idx].c = 0;
        }
    }
}

void record(int prev, int curr) {
    byte pd = prev % 10;
    byte cd = curr % 10;
    int i;

    for (i = 0; i < 100; i++) {
        int z = 0;
        if (transitions[i].a == pd) {
            int t = 0;
            if (transitions[i].b == cd) {
                transitions[i].c++;
                break;
            }
        }
    }
}

void printTransitions(int limit, int last_prime) {
    int i;

    printf("%d primes, last prime considered: %d\n", limit, last_prime);

    for (i = 0; i < 100; i++) {
        if (transitions[i].c > 0) {
            printf("%d->%d  count: %5d  frequency: %.2f\n", transitions[i].a, transitions[i].b, transitions[i].c, 100.0 * transitions[i].c / limit);
        }
    }
}

bool isPrime(int n) {
    int s, t, a1, a2;

    if (n % 2 == 0) return n == 2;
    if (n % 3 == 0) return n == 3;
    if (n % 5 == 0) return n == 5;
    if (n % 7 == 0) return n == 7;
    if (n % 11 == 0) return n == 11;
    if (n % 13 == 0) return n == 13;
    if (n % 17 == 0) return n == 17;
    if (n % 19 == 0) return n == 19;

    // assuming that addition is faster then multiplication
    t = 23;
    a1 = 96;
    a2 = 216;
    s = t * t;
    while (s <= n) {
        if (n % t == 0) return false;

        // first increment
        s += a1;
        t += 2;
        a1 += 24;
        assert(t * t == s);

        if (s <= n) {
            if (n % t == 0) return false;

            // second increment
            s += a2;
            t += 4;
            a2 += 48;
            assert(t * t == s);
        }
    }

    return true;
}

#define LIMIT 1000000
int main() {
    int last_prime = 3, n = 5, count = 2;

    init();
    record(2, 3);

    while (count < LIMIT) {
        if (isPrime(n)) {
            record(last_prime, n);
            last_prime = n;
            count++;
        }
        n += 2;

        if (count < LIMIT) {
            if (isPrime(n)) {
                record(last_prime, n);
                last_prime = n;
                count++;
            }
            n += 4;
        }
    }

    printTransitions(LIMIT, last_prime);

    return 0;
}
