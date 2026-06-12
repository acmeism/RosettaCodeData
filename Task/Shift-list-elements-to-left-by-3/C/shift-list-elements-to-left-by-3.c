#include <stdio.h>

/* in place left shift by 1 */
void lshift(int *l, size_t n) {
    int i, f;
    if (n < 2) return;
    f = l[0];
    for (i = 0; i < n-1; ++i) l[i] = l[i+1];
    l[n-1] = f;
}

int main() {
    int l[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    int i;
    size_t n = 9;
    printf("Original list     : ");
    for (i = 0; i < n; ++i) printf("%d ", l[i]);
    printf("\nShifted left by 3 : ");
    for (i = 0; i < 3; ++i) lshift(l, n);
    for (i = 0; i < n; ++i) printf("%d ", l[i]);
    printf("\n");
    return 0;
}
