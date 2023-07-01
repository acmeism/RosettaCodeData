#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

struct Pair {
    uint64_t v1, v2;
};

struct Pair makePair(uint64_t a, uint64_t b) {
    struct Pair r;
    r.v1 = a;
    r.v2 = b;
    return r;
}

struct Pair solvePell(int n) {
    int x = (int) sqrt(n);

    if (x * x == n) {
        // n is a perfect square - no solution other than 1,0
        return makePair(1, 0);
    } else {
        // there are non-trivial solutions
        int y = x;
        int z = 1;
        int r = 2 * x;
        struct Pair e = makePair(1, 0);
        struct Pair f = makePair(0, 1);
        uint64_t a = 0;
        uint64_t b = 0;

        while (true) {
            y = r * z - y;
            z = (n - y * y) / z;
            r = (x + y) / z;
            e = makePair(e.v2, r * e.v2 + e.v1);
            f = makePair(f.v2, r * f.v2 + f.v1);
            a = e.v2 + x * f.v2;
            b = f.v2;
            if (a * a - n * b * b == 1) {
                break;
            }
        }

        return makePair(a, b);
    }
}

void test(int n) {
    struct Pair r = solvePell(n);
    printf("x^2 - %3d * y^2 = 1 for x = %21llu and y = %21llu\n", n, r.v1, r.v2);
}

int main() {
    test(61);
    test(109);
    test(181);
    test(277);

    return 0;
}
