/* gcc -O3 `pkg-config --cflags glib-2.0` tetraprime.c -o tp `pkg-config --libs glib-2.0` -lprimesieve */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <locale.h>
#include <primesieve.h>
#include <glib.h>

#define TEN_MILLION 10000000

size_t size;
int* primes;

void init() {
    primes = (int*) primesieve_generate_primes(2, TEN_MILLION, &size, INT_PRIMES);
}

bool isTetraPrime(int n) {
    size_t i;
    int p,limit, count = 0, prevFact = 1;
    for (i = 0; i < size; ++i) {
        p = primes[i];
        limit = p*p;
        switch (count){
        case 0:
            limit *= limit;
            break;
        case 1:
            limit *= p;
            break;
        }
        if (limit <= n) {
            while(!(n%p)) {
                if (count == 4 || p == prevFact) return false;
                ++count;
                n /= p;
                prevFact = p;
            }
        } else {
            break;
        }
    }
    if (n > 1) {
        if (count == 4 || p == prevFact) return false;
        ++count;
    }
    return count == 4;
}

int prevPrime(int n) {
    size_t l = 0, r = size, m;
    while (l < r) {
        m = (l + r)/2;
        if (primes[m] > n) {
            r = m;
        } else {
            l = m + 1;
        }
    }
    return primes[r-1];
}

int compare(const void* a, const void* b) {
    int arg1 = *(const int*)a;
    int arg2 = *(const int*)b;
    if (arg1 < arg2) return -1;
    if (arg1 > arg2) return 1;
    return 0;
}

// Note that 'gaps' will only contain even numbers here.
int median(int *gaps, int length) {
    int m = length/2;
    if (length & 1 == 1) return gaps[m];
    return (gaps[m] + gaps[m-1])/2;
}

int main() {
    size_t s;
    int i, p, c, k, length, sevens, min, max, med;
    int j = 100000, sevens1 = 0, sevens2 = 0;
    int *gaps;
    const char *t;
    GArray *tetras1 = g_array_new(FALSE, FALSE, sizeof(int));
    GArray *tetras2 = g_array_new(FALSE, FALSE, sizeof(int));
    GArray *tetras;
    init();
    int highest5 = prevPrime(100000);
    int highest6 = prevPrime(1000000);
    int highest7 = primes[size - 1];
    setlocale(LC_NUMERIC, "");
    for (s = 0; s < size; ++s) {
        p = primes[s];

        // process even numbers first as likely to have most factors
        if (isTetraPrime(p-1) && isTetraPrime(p-2)) {
            g_array_append_val(tetras1, p);
            if ((p-1)%7 == 0 || (p-2)%7 == 0) ++sevens1;
        }

        if (isTetraPrime(p+1) && isTetraPrime(p+2)) {
            g_array_append_val(tetras2, p);
            if ((p+1)%7 == 0 || (p+2)%7 == 0) ++sevens2;
        }

        if (p == highest5 || p == highest6 || p == highest7) {
            for (i = 0; i < 2; ++i) {
                tetras = (i == 0) ? tetras1 : tetras2;
                sevens = (i == 0) ? sevens1 : sevens2;
                c = tetras->len;
                t = (i == 0) ? "preceding" : "following";
                printf("Found %'d primes under %'d whose %s neighboring pair are tetraprimes", c, j, t);
                if (p == highest5) {
                    printf(":\n");
                    for (k = 0; k < tetras->len; ++k) {
                        printf("%5d  ", g_array_index(tetras, int, k));
                        if (!((k+1) % 10)) printf("\n");
                    }
                    printf("\n");
                }
                printf("\nof which %'d have a neighboring pair one of whose factors is 7.\n\n", sevens);
                length = c - 1;
                gaps = (int *)malloc(length * sizeof(int));
                for (k = 0; k < length; ++k) {
                    gaps[k] = g_array_index(tetras, int, k+1) - g_array_index(tetras, int, k);
                }
                qsort(gaps, length, sizeof(int), compare);
                min = gaps[0];
                max = gaps[length - 1];
                med = median(gaps, length);
                printf("Minimum gap between those %'d primes : %'d\n", c, min);
                printf("Median  gap between those %'d primes : %'d\n", c, med);
                printf("Maximum gap between those %'d primes : %'d\n", c, max);
                printf("\n");
                free(gaps);
            }
            j *= 10;
        }
    }
    g_array_free(tetras1, FALSE);
    g_array_free(tetras2, FALSE);
    primesieve_free(primes);
    return 0;
}
