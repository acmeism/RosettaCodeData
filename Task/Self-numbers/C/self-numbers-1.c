#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef unsigned char bool;

#define TRUE 1
#define FALSE 0
#define MILLION 1000000
#define BILLION 1000 * MILLION
#define MAX_COUNT 2*BILLION + 9*9 + 1

void sieve(bool *sv) {
    int n = 0, s[8], a, b, c, d, e, f, g, h, i, j;
    for (a = 0; a < 2; ++a) {
        for (b = 0; b < 10; ++b) {
            s[0] = a + b;
            for (c = 0; c < 10; ++c) {
                s[1] = s[0] + c;
                for (d = 0; d < 10; ++d) {
                    s[2] = s[1] + d;
                    for (e = 0; e < 10; ++e) {
                        s[3] = s[2] + e;
                        for (f = 0; f < 10; ++f) {
                            s[4] = s[3] + f;
                            for (g = 0; g < 10; ++g) {
                                s[5] = s[4] + g;
                                for (h = 0; h < 10; ++h) {
                                    s[6] = s[5] + h;
                                    for (i = 0; i < 10; ++i) {
                                        s[7] = s[6] + i;
                                        for (j = 0; j < 10; ++j) {
                                            sv[s[7] + j+ n++] = TRUE;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

int main() {
    int count = 0;
    clock_t begin = clock();
    bool *p, *sv = (bool*) calloc(MAX_COUNT, sizeof(bool));
    sieve(sv);
    printf("The first 50 self numbers are:\n");
    for (p = sv; p < sv + MAX_COUNT; ++p) {
        if (!*p) {
            if (++count <= 50) printf("%ld ", p-sv);
            if (count == 100 * MILLION) {
                printf("\n\nThe 100 millionth self number is %ld\n", p-sv);
                break;
            }
        }
    }
    free(sv);
    printf("Took %lf seconds.\n", (double)(clock() - begin) / CLOCKS_PER_SEC);
    return 0;
}
