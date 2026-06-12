#include <stdio.h>
#include <stdlib.h>

typedef unsigned long long ulong;

const int BASE = 2;

struct Montgomery {
    ulong m;
    ulong rrm;
    int n;
};

int bitLength(ulong v) {
    int result = 0;
    while (v > 0) {
        v >>= 1;
        result++;
    }
    return result;
}

ulong modPow(ulong b, ulong e, ulong n) {
    ulong result = 1;

    if (n == 1) {
        return 0;
    }

    b = b % n;
    while (e > 0) {
        if (e % 2 == 1) {
            result = (result * b) % n;
        }
        e >>= 1;
        b = (b * b) % n;
    }

    return result;
}

struct Montgomery makeMontgomery(ulong m) {
    struct Montgomery result;

    if (m == 0 || (m & 1) == 0) {
        fprintf(stderr, "m must be greater than zero and odd");
        exit(1);
    }

    result.m = m;
    result.n = bitLength(m);
    result.rrm = (1ULL << (result.n * 2)) % m;

    return result;
}

ulong reduce(struct Montgomery mont, ulong t) {
    ulong a = t;
    int i;

    for (i = 0; i < mont.n; i++) {
        if ((a & 1) == 1) {
            a += mont.m;
        }
        a = a >> 1;
    }

    if (a >= mont.m) {
        a -= mont.m;
    }
    return a;
}

void check(ulong x1, ulong x2, ulong m) {
    struct Montgomery mont = makeMontgomery(m);
    ulong t1 = x1 * mont.rrm;
    ulong t2 = x2 * mont.rrm;

    ulong r1 = reduce(mont, t1);
    ulong r2 = reduce(mont, t2);
    ulong r = 1ULL << mont.n;

    printf("b :  %d\n", BASE);
    printf("n :  %d\n", mont.n);
    printf("r :  %llu\n", r);
    printf("m :  %llu\n", mont.m);
    printf("t1:  %llu\n", t1);
    printf("t2:  %llu\n", t2);
    printf("r1:  %llu\n", r1);
    printf("r2:  %llu\n", r2);
    printf("\n");
    printf("Original x1       : %llu\n", x1);
    printf("Recovered from r1 : %llu\n", reduce(mont, r1));
    printf("Original x2       : %llu\n", x2);
    printf("Recovered from r2 : %llu\n", reduce(mont, r2));

    printf("\nMontgomery computation of x1 ^ x2 mod m :\n");
    ulong prod = reduce(mont, mont.rrm);
    ulong base = reduce(mont, x1 * mont.rrm);
    ulong exp = x2;
    while (bitLength(exp) > 0) {
        if ((exp & 1) == 1) {
            prod = reduce(mont, prod * base);
        }
        exp >>= 1;
        base = reduce(mont, base * base);
    }
    printf("%llu\n", reduce(mont, prod));
    printf("\nAlternate computation of x1 ^ x2 mod m :\n");
    printf("%llu\n", modPow(x1, x2, m));
}

int main() {
    check(41, 11, 1549);

    return 0;
}
