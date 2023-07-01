#include <stdio.h>

void padovanN(int n, size_t t, int *p) {
    int i, j;
    if (n < 2 || t < 3) {
        for (i = 0; i < t; ++i) p[i] = 1;
        return;
    }
    padovanN(n-1, t, p);
    for (i = n + 1; i < t; ++i) {
        p[i] = 0;
        for (j = i - 2; j >= i - n - 1; --j) p[i] += p[j];
    }
}

int main() {
    int n, i;
    const size_t t = 15;
    int p[t];
    printf("First %ld terms of the Padovan n-step number sequences:\n", t);
    for (n = 2; n <= 8; ++n) {
        for (i = 0; i < t; ++i) p[i] = 0;
        padovanN(n, t, p);
        printf("%d: ", n);
        for (i = 0; i < t; ++i) printf("%3d ", p[i]);
        printf("\n");
    }
    return 0;
}
