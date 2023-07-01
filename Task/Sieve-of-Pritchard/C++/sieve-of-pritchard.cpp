/* Sieve of Pritchard in C++, as described at https://en.wikipedia.org/wiki/Sieve_of_Pritchard */
/* Simple but high-performance implementation using a simple array of integers and a bit array (using bytes for speed). */
/* 2 <= N <= 1000000000 */
/* (like the standard Sieve of Eratosthenes, this algorithm is not suitable for very large N due to memory requirements) */

#include <cstring>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctime>

void Extend (uint32_t w[], uint32_t &w_end, uint32_t &length, uint32_t n, bool d[], uint32_t &w_end_max) {
    /* Rolls full wheel W up to n, and sets length=n */
    uint32_t i, j, x;
    i = 0; j = w_end;
    x = length + 1; /* length+w[0] */
    while (x <= n) {
        w[++j] = x; /* Append x to the ordered set W */
        d[x] = false;
        x = length + w[++i];
    }
    length = n; w_end = j;
    if (w_end > w_end_max) w_end_max = w_end;
}

void Delete (uint32_t w[], uint32_t length, uint32_t p, bool d[], uint32_t &imaxf) {
    /* Deletes multiples p*w[i] of p from W, and sets imaxf to last i for deletion */
    uint32_t i, x;
    i = 0;
    x = p; /* p*w[0]=p*1 */
    while (x <= length) {
        d[x] = true; /* Remove x from W; */
        x = p*w[++i];
    }
    imaxf = i-1;
}

void Compress(uint32_t w[], bool d[], uint32_t to, uint32_t &w_end) {
    /* Removes deleted values in w[0..to], and if to=w_end, updates w_end, otherwise pads with zeros on right */
    uint32_t i, j;
    j = 0;
    for (i=1; i <= to; i++) {
        if (!d[w[i]]) {
            w[++j] = w[i];
        }
    }
    if (to == w_end) {
        w_end = j;
    } else {
        for (uint32_t k=j+1; k <= to; k++) w[k] = 0;
    }
}

void Sift(uint32_t N, bool printPrimes, uint32_t &nrPrimes, uint32_t &vBound) {
    /* finds the nrPrimes primes up to N, printing them if printPrimes */
    uint32_t *w = new uint32_t[N/4+5];
    bool *d = new bool[N+1];
    uint32_t w_end, length;
    /* representation invariant (for the main loop): */
    /* if length < N (so W is a complete wheel), w[0..w_end] is the ordered set W; */
    /* otherwise, w[0..w_end], omitting zeros and values w with d[w] true, is the ordered set W, */
    /* and no values <= N/p are omitted */
    uint32_t w_end_max, p, imaxf;
    /* W,k,length = {1},1,2: */
    w_end = 0; w[0] = 1;
    w_end_max = 0;
    length = 2;
    /* Pr = {2}: */
    nrPrimes = 1;
    if (printPrimes) printf("%d", 2);
    p = 3;
    /* invariant: p = p_(k+1) and W = W_k inter {1,...,N} and length = min(P_k,N) and Pr = the first k primes */
    /* (where p_i denotes the i'th prime, W_i denotes the i'th wheel, P_i denotes the product of the first i primes) */
    while (p*p <= N) {
        /* Append p to Pr: */
        nrPrimes++;
        if (printPrimes) printf(" %d", p);
        if (length < N) {
            /* Extend W with length to minimum of p*length and N: */
            Extend (w, w_end, length, std::min(p*length,N), d, w_end_max);
        }
        Delete(w, length, p, d, imaxf);
        Compress(w, d, (length < N ? w_end : imaxf), w_end);
        /* p = next(W, 1): */
        p = w[1];
        if (p == 0) break; /* next p is after zeroed section so is too big */
        /* k++ */
    }
    if (length < N) {
        /* Extend full wheel W,length to N: */
        Extend (w, w_end, length, N, d, w_end_max);
    }
    /* gather remaining primes: */
    for (uint32_t i=1; i <= w_end; i++) {
        if (w[i] == 0 || d[w[i]]) continue;
        if (printPrimes) printf(" %d", w[i]);
        nrPrimes++;
    }
    vBound = w_end_max+1;
}

int main (int argc, char *argw[]) {
    bool error = false;
    bool printPrimes = false;
    uint32_t N, nrPrimes, vBound;
    if (argc == 3) {
        if (strcmp(argw[2], "-p") == 0) {
            printPrimes = true;
            argc--;
        } else {
            error = true;
        }
    }
    if (argc == 2) {
        N = atoi(argw[1]);
        if (N < 2 || N > 1000000000) error = true;
    } else {
        error = true;
    }
    if (error) {
        printf("call with: %s N -p where 2 <= N <= 1000000000 and -p to print the primes is optional \n", argw[0]);
        exit(1);
    }
    int start_s = clock();
    Sift(N, printPrimes, nrPrimes, vBound);
    int stop_s=clock();
    printf("\n%d primes up to %lu found in %.3f ms using array w[%d]\n", nrPrimes,
      (unsigned long)N, (stop_s-start_s)*1E3/double(CLOCKS_PER_SEC), vBound);
}
