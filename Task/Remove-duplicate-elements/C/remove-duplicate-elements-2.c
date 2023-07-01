#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

/* Returns `true' if element `e' is in array `a'. Otherwise, returns `false'.
 * Checks only the first `n' elements. Pure, O(n).
 */
bool elem(int *a, size_t n, int e)
{
    for (size_t i = 0; i < n; ++i)
        if (a[i] == e)
            return true;

    return false;
}

/* Removes the duplicates in array `a' of given length `n'. Returns the number
 * of unique elements. In-place, order preserving, O(n ^ 2).
 */
size_t nub(int *a, size_t n)
{
    size_t m = 0;

    for (size_t i = 0; i < n; ++i)
        if (!elem(a, m, a[i]))
            a[m++] = a[i];

    return m;
}

/* Out-place version of `nub'. Pure, order preserving, alloc < n * sizeof(int)
 * bytes, O(n ^ 2).
 */
size_t nub_new(int **b, int *a, size_t n)
{
    int *c = malloc(n * sizeof(int));
    memcpy(c, a, n * sizeof(int));
    int m = nub(c, n);
    *b = malloc(m * sizeof(int));
    memcpy(*b, c, m * sizeof(int));
    free(c);
    return m;
}

int main(void)
{
    int a[] = {1, 2, 1, 4, 5, 2, 15, 1, 3, 4};
    int *b;

    size_t n = nub_new(&b, a, sizeof(a) / sizeof(a[0]));

    for (size_t i = 0; i < n; ++i)
        printf("%d ", b[i]);
    puts("");

    free(b);
    return 0;
}
