#include <stdio.h>
#include <stdlib.h>

int* mertens_numbers(int max) {
    int* m = malloc((max + 1) * sizeof(int));
    if (m == NULL)
        return m;
    m[1] = 1;
    for (int n = 2; n <= max; ++n) {
        m[n] = 1;
        for (int k = 2; k <= n; ++k)
            m[n] -= m[n/k];
    }
    return m;
}

int main() {
    const int max = 1000;
    int* mertens = mertens_numbers(max);
    if (mertens == NULL) {
        fprintf(stderr, "Out of memory\n");
        return 1;
    }
    printf("First 199 Mertens numbers:\n");
    const int count = 200;
    for (int i = 0, column = 0; i < count; ++i) {
        if (column > 0)
            printf(" ");
        if (i == 0)
            printf("  ");
        else
            printf("%2d", mertens[i]);
        ++column;
        if (column == 20) {
            printf("\n");
            column = 0;
        }
    }
    int zero = 0, cross = 0, previous = 0;
    for (int i = 1; i <= max; ++i) {
        int m = mertens[i];
        if (m == 0) {
            ++zero;
            if (previous != 0)
                ++cross;
        }
        previous = m;
    }
    free(mertens);
    printf("M(n) is zero %d times for 1 <= n <= %d.\n", zero, max);
    printf("M(n) crosses zero %d times for 1 <= n <= %d.\n", cross, max);
    return 0;
}
