#include <stdio.h>
#include <stdlib.h>

#define TRUE 1
#define FALSE 0
#define LIMIT 100

typedef int bool;

int compareInts(const void *a, const void *b) {
    int aa = *(int *)a;
    int bb = *(int *)b;
    return aa - bb;
}

bool contains(int a[], int b, size_t len) {
    int i;
    for (i = 0; i < len; ++i) {
        if (a[i] == b) return TRUE;
    }
    return FALSE;
}

int gcd(int a, int b) {
    while (a != b) {
        if (a > b)
            a -= b;
        else
            b -= a;
    }
    return a;
}

bool areSame(int s[], int t[], size_t len) {
    int i;
    qsort(s, len, sizeof(int), compareInts);
    qsort(t, len, sizeof(int), compareInts);
    for (i = 0; i < len; ++i) {
        if (s[i] != t[i]) return FALSE;
    }
    return TRUE;
}

int main() {
    int s, n, i;
    int starts[5] = {2, 5, 7, 9, 10};
    int ekg[5][LIMIT];
    for (s = 0; s < 5; ++s) {
        ekg[s][0] = 1;
        ekg[s][1] = starts[s];
        for (n = 2; n < LIMIT; ++n) {
            for (i = 2; ; ++i) {
                // a potential sequence member cannot already have been used
                // and must have a factor in common with previous member
                if (!contains(ekg[s], i, n) && gcd(ekg[s][n - 1], i) > 1) {
                    ekg[s][n] = i;
                    break;
                }
            }
        }
        printf("EKG(%2d): [", starts[s]);
        for (i = 0; i < 30; ++i) printf("%d ", ekg[s][i]);
        printf("\b]\n");
    }

    // now compare EKG5 and EKG7 for convergence
    for (i = 2; i < LIMIT; ++i) {
        if (ekg[1][i] == ekg[2][i] && areSame(ekg[1], ekg[2], i)) {
            printf("\nEKG(5) and EKG(7) converge at term %d\n", i + 1);
            return 0;
        }
    }
    printf("\nEKG5(5) and EKG(7) do not converge within %d terms\n", LIMIT);
    return 0;
}
