#include <math.h>
#include <stdint.h>
#include <stdio.h>

static uint64_t state;
static const uint64_t STATE_MAGIC = 0x2545F4914F6CDD1D;

void seed(uint64_t num) {
    state = num;
}

uint32_t next_int() {
    uint64_t x;
    uint32_t answer;

    x = state;
    x = x ^ (x >> 12);
    x = x ^ (x << 25);
    x = x ^ (x >> 27);
    state = x;
    answer = ((x * STATE_MAGIC) >> 32);

    return answer;
}

float next_float() {
    return (float)next_int() / (1LL << 32);
}

int main() {
    int counts[5] = { 0, 0, 0, 0, 0 };
    int i;

    seed(1234567);
    printf("%u\n", next_int());
    printf("%u\n", next_int());
    printf("%u\n", next_int());
    printf("%u\n", next_int());
    printf("%u\n", next_int());
    printf("\n");

    seed(987654321);
    for (i = 0; i < 100000; i++) {
        int j = (int)floor(next_float() * 5.0);
        counts[j]++;
    }
    for (i = 0; i < 5; i++) {
        printf("%d: %d\n", i, counts[i]);
    }

    return 0;
}
