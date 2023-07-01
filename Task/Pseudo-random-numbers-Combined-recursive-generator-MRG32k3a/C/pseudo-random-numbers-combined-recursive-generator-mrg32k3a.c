#include <math.h>
#include <stdio.h>
#include <stdint.h>

int64_t mod(int64_t x, int64_t y) {
    int64_t m = x % y;
    if (m < 0) {
        if (y < 0) {
            return m - y;
        } else {
            return m + y;
        }
    }
    return m;
}

// Constants
// First generator
const static int64_t a1[3] = { 0, 1403580, -810728 };
const static int64_t m1 = (1LL << 32) - 209;
// Second generator
const static int64_t a2[3] = { 527612, 0, -1370589 };
const static int64_t m2 = (1LL << 32) - 22853;

const static int64_t d = (1LL << 32) - 209 + 1; // m1 + 1

// the last three values of the first generator
static int64_t x1[3];
// the last three values of the second generator
static int64_t x2[3];

void seed(int64_t seed_state) {
    x1[0] = seed_state;
    x1[1] = 0;
    x1[2] = 0;

    x2[0] = seed_state;
    x2[1] = 0;
    x2[2] = 0;
}

int64_t next_int() {
    int64_t x1i = mod((a1[0] * x1[0] + a1[1] * x1[1] + a1[2] * x1[2]), m1);
    int64_t x2i = mod((a2[0] * x2[0] + a2[1] * x2[1] + a2[2] * x2[2]), m2);
    int64_t z = mod(x1i - x2i, m1);

    // keep last three values of the first generator
    x1[2] = x1[1];
    x1[1] = x1[0];
    x1[0] = x1i;

    // keep last three values of the second generator
    x2[2] = x2[1];
    x2[1] = x2[0];
    x2[0] = x2i;

    return z + 1;
}

double next_float() {
    return (double)next_int() / d;
}

int main() {
    int counts[5] = { 0, 0, 0, 0, 0 };
    int i;

    seed(1234567);
    printf("%lld\n", next_int());
    printf("%lld\n", next_int());
    printf("%lld\n", next_int());
    printf("%lld\n", next_int());
    printf("%lld\n", next_int());
    printf("\n");

    seed(987654321);
    for (i = 0; i < 100000; i++) {
        int64_t value = floor(next_float() * 5);
        counts[value]++;
    }
    for (i = 0; i < 5; i++) {
        printf("%d: %d\n", i, counts[i]);
    }

    return 0;
}
