#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define N 2200
#define N2 2200 * 2200 * 2

int main(int argc, char **argv) {
    int a, b, c, d, a2, s = 3, s1, s2;
    int r[N + 1];
    memset(r, 0, sizeof(r));
    int *ab = calloc(N2 + 1, sizeof(int));  // allocate on heap, zero filled

    for (a = 1; a <= N; a++) {
        a2 = a * a;
        for (b = a; b <= N; b++) ab[a2 + b * b] = 1;
    }

    for (c = 1; c <= N; c++) {
        s1 = s;
        s += 2;
        s2 = s;
        for (d = c + 1; d <= N; d++) {
            if (ab[s1]) r[d] = 1;
            s1 += s2;
            s2 += 2;
        }
    }

    for (d = 1; d <= N; d++) {
        if (!r[d]) printf("%d ", d);
    }
    printf("\n");
    free(ab);
    return 0;
}
