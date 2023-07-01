#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef unsigned char bool;

#define TRUE 1
#define FALSE 0
#define MILLION 1000000LL
#define BILLION 1000 * MILLION
#define MAX_COUNT 103LL*10000*10000 + 11*9 + 1

int digitSum[10000];

void init() {
    int i = 9999, s, t, a, b, c, d;
    for (a = 9; a >= 0; --a) {
        for (b = 9; b >= 0; --b) {
            s = a + b;
            for (c = 9; c >= 0; --c) {
                t = s + c;
                for (d = 9; d >= 0; --d) {
                    digitSum[i] = t + d;
                    --i;
                }
            }
        }
    }
}

void sieve(bool *sv) {
    int a, b, c;
    long long s, n = 0;
    for (a = 0; a < 103; ++a) {
        for (b = 0; b < 10000; ++b) {
            s = digitSum[a] + digitSum[b] + n;
            for (c = 0; c < 10000; ++c) {
                sv[digitSum[c]+s] = TRUE;
                ++s;
            }
            n += 10000;
        }
    }
}

int main() {
    long long count = 0, limit = 1;
    clock_t begin = clock(), end;
    bool *p, *sv = (bool*) calloc(MAX_COUNT, sizeof(bool));
    init();
    sieve(sv);
    printf("Sieving took %lf seconds.\n", (double)(clock() - begin) / CLOCKS_PER_SEC);
    printf("\nThe first 50 self numbers are:\n");
    for (p = sv; p < sv + MAX_COUNT; ++p) {
        if (!*p) {
            if (++count <= 50) {
                printf("%ld ", p-sv);
            } else {
                printf("\n\n     Index  Self number\n");
                break;
            }
        }
    }
    count = 0;
    for (p = sv; p < sv + MAX_COUNT; ++p) {
        if (!*p) {
            if (++count == limit) {
                printf("%10lld  %11ld\n", count, p-sv);
                limit *= 10;
                if (limit == 10 * BILLION) break;
            }
        }
    }
    free(sv);
    printf("\nOverall took %lf seconds.\n", (double)(clock() - begin) / CLOCKS_PER_SEC);
    return 0;
}
