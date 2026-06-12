#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <locale.h>
#include <gmp.h>

#define MAX 50000000

typedef uint64_t u64;

int *primeSieve(int limit, int *length) {
    int i, p, *primes;
    int j, pc = 0;
    limit++;
    // True denotes composite, false denotes prime.
    bool *c = calloc(limit, sizeof(bool)); // all false by default
    c[0] = true;
    c[1] = true;
    for (i = 4; i < limit; i += 2) c[i] = true;
    p = 3; // Start from 3.
    while (true) {
        u64 p2 = p * p;
        if (p2 >= limit) break;
        for (i = p2; i < limit; i += 2 * p) c[i] = true;
        while (true) {
            p += 2;
            if (!c[p]) break;
        }
    }
    for (i = 0; i < limit; ++i) {
        if (!c[i]) ++pc;
    }
    primes = (int *)malloc(pc * sizeof(u64));
    for (i = 0, j = 0; i < limit; ++i) {
        if (!c[i]) primes[j++] = i;
    }
    free(c);
    *length = pc;
    return primes;
}

int calmoPrimes(int limit, int *primes, int len, int *sIndices, int *eIndices, u64 *sums, int *ilen) {
    int i, j, temp, pc = len, longest = 0, ic = 0;
    bool isEven;
    u64 sum = 0, sum2;
    mpz_t bsum;
    mpz_init(bsum);
    if (limit < MAX) {
        for (i = 0; i < len; ++i) {
            if (primes[i] > limit) {
                pc = i;
                break;
            }
        }
    }
    for (i = 0; i < pc; ++i) sum += primes[i];
    for (i = 0; i < pc; ++i) {
        if (pc - i < longest) break;
        if (i > 0) sum -= primes[i-1];
        isEven = i == 0;
        sum2 = sum;
        for (j = pc - 1; j >= i; --j) {
            temp = j - i + 1;
            if (temp < longest) break;
            if (j < pc - 1) sum2 -= primes[j+1];
            if ((temp % 2) == 0 != isEven) continue;
            mpz_set_ui(bsum, sum2);
            if (mpz_probab_prime_p(bsum, 5) > 0) {
                if (temp > longest) {
                    longest = temp;
                    ic = 0;
                }
                sIndices[ic] = i;
                eIndices[ic] = j;
                sums[ic] = sum2;
                ++ic;
                break;
            }
        }
    }
    *ilen = ic;
    return longest;
}

int main() {
    int i, j, k, len, ilen, limit, longest;
    int *primes = primeSieve(MAX, &len);
    int limits[6] = {100, 250, 5000, 10000, 500000, 50000000};
    setlocale(LC_NUMERIC, "");
    int sIndices[5];
    int eIndices[5];
    u64 sums[5];
    for (i = 0; i < 6; ++i) {
        limit = limits[i];
        longest = calmoPrimes(limit, primes, len, sIndices, eIndices, sums, &ilen);
        printf("For primes up to %'d the longest sequence(s) of CalmoSoft primes\n", limit);
        printf("having a length of %'d is/are:\n\n", longest);
        for (j = 0; j < ilen; ++j) {
            char cps[130] = "";
            char buf[20];
            int bytes = 0, totalBytes = 0;
            for (k = sIndices[j]; k <= sIndices[j]+5; ++k) {
                bytes = sprintf(buf, "%d + ", primes[k]);
                strcpy(cps + totalBytes, buf);
                totalBytes += bytes;
            }
            strcpy(cps + totalBytes, ".. + ");
            totalBytes += 5;
            for (k = eIndices[j]-5; k <= eIndices[j]; ++k) {
                bytes = sprintf(buf, "%d + ", primes[k]);
                strcpy(cps + totalBytes, buf);
                totalBytes += bytes;
            }
            cps[totalBytes-3] = '\0';
            printf("%s = %'ld\n", cps, sums[j]);
        }
        printf("\n");
    }
    free(primes);
    return 0;
}
