#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <gmp.h>

bool *sieve(int limit) {
    int i, p;
    limit++;
    // True denotes composite, false denotes prime.
    bool *c = calloc(limit, sizeof(bool)); // all false by default
    c[0] = true;
    c[1] = true;
    for (i = 4; i < limit; i += 2) c[i] = true;
    p = 3; // Start from 3.
    while (true) {
        int p2 = p * p;
        if (p2 >= limit) break;
        for (i = p2; i < limit; i += 2 * p) c[i] = true;
        while (true) {
            p += 2;
            if (!c[p]) break;
        }
    }
    return c;
}

const char *ord(int count) {
    return (count == 1) ? "st" :
           (count == 2) ? "nd" :
           (count == 3) ? "rd" : "th";
}

int main() {
    bool *c = sieve(12000);
    char sw[6000] = "";
    char tmp[20];
    int count = 0, p = 1, ix = 0, i;
    mpz_t n;
    mpz_init(n);
    printf("The known Smarandache-Wellin primes are:\n");
    while (count < 8) {
        while (c[++p]);
        sprintf(tmp, "%d", p);
        strcat(sw, tmp);
        mpz_set_str(n, sw, 10);
        if (mpz_probab_prime_p(n, 15) > 0) {
            count++;
            size_t le = strlen(sw);
            char sws[44];
            if (le < 5) {
                strcpy(sws, sw);
            } else {
                strncpy(sws, sw, 20);
                strcpy(sws + 20, "...");
                strncpy(sws + 23, sw + le - 20, 21);
            }
            printf("%2d%s: index %4d  digits %4ld  last prime %5d -> %s\n", count, ord(count), ix+1, le, p, sws);
        }
        ix++;
    }

    printf("\nThe first 20 Derived Smarandache-Wellin primes are:\n");
    int freqs[10] = {0};
    count = 0;
    p = 1;
    ix = 0;
    while (count < 20) {
        while (c[++p]);
        sprintf(tmp, "%d", p);
        for (i = 0; i < strlen(tmp); ++i) freqs[tmp[i]-48]++;
        char dsw[40] = "";
        for (i = 0; i < 10; ++i) {
            sprintf(tmp, "%d", freqs[i]);
            strcat(dsw, tmp);
        }
        int idx = -1;
        for (i = 0; i < strlen(dsw); ++i) {
            if (dsw[i] != '0') {
                idx = i;
                break;
            }
        }
        mpz_set_str(n, dsw + idx, 10);
        if (mpz_probab_prime_p(n, 15) > 0) {
            count++;
            printf("%2d%s: index %4d  prime %s\n", count, ord(count), ix+1, dsw + idx);
        }
        ix++;
    }
    free(c);
    return 0;
}
