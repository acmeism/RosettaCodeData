#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

const uint8_t masks[8] = {1, 2, 4, 8, 16, 32, 64, 128};

#define half(n) ((int64_t)((n) - 1) >> 1)

#define divide(nm, d) ((uint64_t)((double)nm / (double)d))

int64_t countPrimes(uint64_t n) {
    if (n < 9) return (n < 2) ? 0 : ((int64_t)n + 1) / 2;
    uint64_t rtlmt = (uint64_t)sqrt((double)n);
    int64_t mxndx = (int64_t)((rtlmt - 1) / 2);
    int arrlen = (int)(mxndx + 1);
    uint32_t *smalls = malloc(arrlen * 4);
    uint32_t *roughs = malloc(arrlen * 4);
    int64_t *larges  = malloc(arrlen * 8);
    for (int i = 0; i < arrlen; ++i) {
        smalls[i] = (uint32_t)i;
        roughs[i] = (uint32_t)(i + i + 1);
        larges[i] = (int64_t)((n/(uint64_t)(i + i + 1) - 1) / 2);
    }
    int cullbuflen = (int)((mxndx + 8) / 8);
    uint8_t *cullbuf = calloc(cullbuflen, 1);
    int64_t nbps = 0;
    int rilmt = arrlen;
    for (int64_t i = 1; ; ++i) {
        int64_t sqri = (i + i) * (i + 1);
        if (sqri > mxndx) break;
        if (cullbuf[i >> 3] & masks[i & 7]) continue;
        cullbuf[i >> 3] |= masks[i & 7];
        uint64_t bp = (uint64_t)(i + i + 1);
        for (int64_t c = sqri; c < (int64_t)arrlen; c += (int64_t)bp) {
            cullbuf[c >> 3] |= masks[c & 7];
        }
        int nri = 0;
        for (int ori = 0; ori < rilmt; ++ori) {
            uint32_t r = roughs[ori];
            int64_t rci = (int64_t)(r >> 1);
            if (cullbuf[rci >> 3] & masks[rci & 7]) continue;
            uint64_t d = (uint64_t)r * bp;
            int64_t t = (d <= rtlmt) ? larges[(int64_t)smalls[d >> 1] - nbps] :
                                       (int64_t)smalls[half(divide(n, d))];
            larges[nri] = larges[ori] - t + nbps;
            roughs[nri] = r;
            nri++;
        }
        int64_t si = mxndx;
        for (uint64_t pm = (rtlmt/bp - 1) | 1; pm >= bp; pm -= 2) {
            uint32_t c = smalls[pm >> 1];
            uint64_t e = (pm * bp) >> 1;
            for ( ; si >= (int64_t)e; --si) smalls[si] -= c - (uint32_t)nbps;
        }
        rilmt = nri;
        nbps++;
    }
    int64_t ans = larges[0] + (int64_t)((rilmt + 2*(nbps - 1)) * (rilmt - 1) / 2);
    int ri, sri;
    for (ri = 1; ri < rilmt; ++ri) ans -= larges[ri];
    for (ri = 1; ; ++ri) {
        uint64_t p = (uint64_t)roughs[ri];
        uint64_t m = n / p;
        int ei = (int)smalls[half((uint64_t)m/p)] - nbps;
        if (ei <= ri) break;
        ans -= (int64_t)((ei - ri) * (nbps + ri - 1));
        for (sri = ri + 1; sri < ei + 1; ++sri) {
            ans += (int64_t)smalls[half(divide(m, (uint64_t)roughs[sri]))];
        }
    }
    free(smalls);
    free(roughs);
    free(larges);
    free(cullbuf);
    return ans + 1;
}

int main() {
    uint64_t n;
    int i;
    clock_t start = clock();
    for (i = 0, n = 1; i < 10; ++i, n *= 10) {
        printf("10^%d %ld\n", i, countPrimes(n));
    }
    clock_t end = clock();
    printf("\nTook %f seconds\n", (double) (end - start) / CLOCKS_PER_SEC);
    return 0;
}
