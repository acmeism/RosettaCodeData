#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

uint64_t modpow(uint64_t a, uint64_t b, uint64_t n) {
    uint64_t x = 1, y = a;
    while (b > 0) {
        if (b % 2 == 1) {
            x = (x * y) % n; // multiplying with base
        }
        y = (y * y) % n; // squaring the base
        b /= 2;
    }
    return x % n;
}

struct Solution {
    uint64_t root1, root2;
    bool exists;
};

struct Solution makeSolution(uint64_t root1, uint64_t root2, bool exists) {
    struct Solution sol;
    sol.root1 = root1;
    sol.root2 = root2;
    sol.exists = exists;
    return sol;
}

struct Solution ts(uint64_t n, uint64_t p) {
    uint64_t q = p - 1;
    uint64_t ss = 0;
    uint64_t z = 2;
    uint64_t c, r, t, m;

    if (modpow(n, (p - 1) / 2, p) != 1) {
        return makeSolution(0, 0, false);
    }

    while ((q & 1) == 0) {
        ss += 1;
        q >>= 1;
    }

    if (ss == 1) {
        uint64_t r1 = modpow(n, (p + 1) / 4, p);
        return makeSolution(r1, p - r1, true);
    }

    while (modpow(z, (p - 1) / 2, p) != p - 1) {
        z++;
    }

    c = modpow(z, q, p);
    r = modpow(n, (q + 1) / 2, p);
    t = modpow(n, q, p);
    m = ss;

    while (true) {
        uint64_t i = 0, zz = t;
        uint64_t b = c, e;
        if (t == 1) {
            return makeSolution(r, p - r, true);
        }
        while (zz != 1 && i < (m - 1)) {
            zz = zz * zz % p;
            i++;
        }
        e = m - i - 1;
        while (e > 0) {
            b = b * b % p;
            e--;
        }
        r = r * b % p;
        c = b * b % p;
        t = t * c % p;
        m = i;
    }
}

void test(uint64_t n, uint64_t p) {
    struct Solution sol = ts(n, p);
    printf("n = %llu\n", n);
    printf("p = %llu\n", p);
    if (sol.exists) {
        printf("root1 = %llu\n", sol.root1);
        printf("root2 = %llu\n", sol.root2);
    } else {
        printf("No solution exists\n");
    }
    printf("\n");
}

int main() {
    test(10, 13);
    test(56, 101);
    test(1030, 10009);
    test(1032, 10009);
    test(44402, 100049);

    return 0;
}
