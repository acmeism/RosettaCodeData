#include <stdio.h>
#include <stdlib.h>

void countDigitsInE(int n) {
    int i, a, c, col, td = 1;
    int *v = malloc(n * sizeof(int));
    for (i = 0; i < n; ++i) v[i] = 1;
    int dc[10] = {0};
    dc[2] = 1;  /* to count the non-fractional digit */
    for (col = 1; col < 2 * n; ++col) {
        a = n + 1;
        c = 0;
        for (i = 0; i < n; ++i) {
            c += v[i] * 10;
            v[i] = c % a;
            c /= a--;
        }
        dc[c]++;
        td++;
    }
    free(v);
    for (i = 0; i < 10; ++i) printf("%d: %d\n", i, dc[i]);
    printf("Total digits: %d\n", td);
}

int main() {
    countDigitsInE(2000);
    printf("\n");
    countDigitsInE(3000);
    return 0;
}
