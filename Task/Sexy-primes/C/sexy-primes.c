#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>

#define TRUE 1
#define FALSE 0

typedef unsigned char bool;

void sieve(bool *c, int limit) {
    int i, p = 3, p2;
    // TRUE denotes composite, FALSE denotes prime.
    c[0] = TRUE;
    c[1] = TRUE;
    // no need to bother with even numbers over 2 for this task
    for (;;) {
        p2 = p * p;
        if (p2 >= limit) {
            break;
        }
        for (i = p2; i < limit; i += 2*p) {
            c[i] = TRUE;
        }
        for (;;) {
            p += 2;
            if (!c[p]) {
                break;
            }
        }
    }
}

void printHelper(const char *cat, int len, int lim, int n) {
    const char *sp = strcmp(cat, "unsexy primes") ? "sexy prime " : "";
    const char *verb = (len == 1) ? "is" : "are";
    printf("Number of %s%s less than %'d = %'d\n", sp, cat, lim, len);
    printf("The last %d %s:\n", n, verb);
}

void printArray(int *a, int len) {
    int i;
    printf("[");
    for (i = 0; i < len; ++i) printf("%d ", a[i]);
    printf("\b]");
}

int main() {
    int i, ix, n, lim = 1000035;
    int pairs = 0, trips = 0, quads = 0, quins = 0, unsexy = 2;
    int pr = 0, tr = 0, qd = 0, qn = 0, un = 2;
    int lpr = 5, ltr = 5, lqd = 5, lqn = 5, lun = 10;
    int last_pr[5][2], last_tr[5][3], last_qd[5][4], last_qn[5][5];
    int last_un[10];
    bool *sv = calloc(lim - 1, sizeof(bool)); // all FALSE by default
    setlocale(LC_NUMERIC, "");
    sieve(sv, lim);

    // get the counts first
    for (i = 3; i < lim; i += 2) {
        if (i > 5 && i < lim-6 && !sv[i] && sv[i-6] && sv[i+6]) {
            unsexy++;
            continue;
        }
        if (i < lim-6 && !sv[i] && !sv[i+6]) {
            pairs++;
        } else continue;

        if (i < lim-12 && !sv[i+12]) {
            trips++;
        } else continue;

        if (i < lim-18 && !sv[i+18]) {
            quads++;
        } else continue;

        if (i < lim-24 && !sv[i+24]) {
            quins++;
        }
    }
    if (pairs < lpr) lpr = pairs;
    if (trips < ltr) ltr = trips;
    if (quads < lqd) lqd = quads;
    if (quins < lqn) lqn = quins;
    if (unsexy < lun) lun = unsexy;

    // now get the last 'x' for each category
    for (i = 3; i < lim; i += 2) {
        if (i > 5 && i < lim-6 && !sv[i] && sv[i-6] && sv[i+6]) {
            un++;
            if (un > unsexy - lun) {
                last_un[un + lun - 1 - unsexy] = i;
            }
            continue;
        }
        if (i < lim-6 && !sv[i] && !sv[i+6]) {
            pr++;
            if (pr > pairs - lpr) {
                ix = pr + lpr - 1 - pairs;
                last_pr[ix][0] = i; last_pr[ix][1] = i + 6;
            }
        } else continue;

        if (i < lim-12 && !sv[i+12]) {
            tr++;
            if (tr > trips - ltr) {
                ix = tr + ltr - 1 - trips;
                last_tr[ix][0] = i; last_tr[ix][1] = i + 6;
                last_tr[ix][2] = i + 12;
            }
        } else continue;

        if (i < lim-18 && !sv[i+18]) {
            qd++;
            if (qd > quads - lqd) {
                ix = qd + lqd - 1 - quads;
                last_qd[ix][0] = i; last_qd[ix][1] = i + 6;
                last_qd[ix][2] = i + 12; last_qd[ix][3] = i + 18;
            }
        } else continue;

        if (i < lim-24 && !sv[i+24]) {
            qn++;
            if (qn > quins - lqn) {
                ix = qn + lqn - 1 - quins;
                last_qn[ix][0] = i; last_qn[ix][1] = i + 6;
                last_qn[ix][2] = i + 12; last_qn[ix][3] = i + 18;
                last_qn[ix][4] = i + 24;
            }
        }
    }

    printHelper("pairs", pairs, lim, lpr);
    printf("  [");
    for (i = 0; i < lpr; ++i) {
        printArray(last_pr[i], 2);
        printf("\b] ");
    }
    printf("\b]\n\n");

    printHelper("triplets", trips, lim, ltr);
    printf("  [");
    for (i = 0; i < ltr; ++i) {
        printArray(last_tr[i], 3);
        printf("\b] ");
    }
    printf("\b]\n\n");

    printHelper("quadruplets", quads, lim, lqd);
    printf("  [");
    for (i = 0; i < lqd; ++i) {
        printArray(last_qd[i], 4);
        printf("\b] ");
    }
    printf("\b]\n\n");

    printHelper("quintuplets", quins, lim, lqn);
    printf("  [");
    for (i = 0; i < lqn; ++i) {
        printArray(last_qn[i], 5);
        printf("\b] ");
    }
    printf("\b]\n\n");

    printHelper("unsexy primes", unsexy, lim, lun);
    printf("  [");
    printArray(last_un, lun);
    printf("\b]\n");
    free(sv);
    return 0;
}
