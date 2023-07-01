#include <stdio.h>
#include <stdlib.h>

void pascal_low(int **mat, int n) {
    int i, j;

    for (i = 0; i < n; ++i)
        for (j = 0; j < n; ++j)
            if (i < j)
                mat[i][j] = 0;
            else if (i == j || j == 0)
                mat[i][j] = 1;
            else
                mat[i][j] = mat[i - 1][j - 1] + mat[i - 1][j];
}

void pascal_upp(int **mat, int n) {
    int i, j;

    for (i = 0; i < n; ++i)
        for (j = 0; j < n; ++j)
            if (i > j)
                mat[i][j] = 0;
            else if (i == j || i == 0)
                mat[i][j] = 1;
            else
                mat[i][j] = mat[i - 1][j - 1] + mat[i][j - 1];
}

void pascal_sym(int **mat, int n) {
    int i, j;

    for (i = 0; i < n; ++i)
        for (j = 0; j < n; ++j)
            if (i == 0 || j == 0)
                mat[i][j] = 1;
            else
                mat[i][j] = mat[i - 1][j] + mat[i][j - 1];
}

int main(int argc, char * argv[]) {
    int **mat;
    int i, j, n;

    /* Input size of the matrix */
    n = 5;

    /* Matrix allocation */
    mat = calloc(n, sizeof(int *));
    for (i = 0; i < n; ++i)
        mat[i] = calloc(n, sizeof(int));

    /* Matrix computation */
    printf("=== Pascal upper matrix ===\n");
    pascal_upp(mat, n);
    for (i = 0; i < n; i++)
        for (j = 0; j < n; j++)
            printf("%4d%c", mat[i][j], j < n - 1 ? ' ' : '\n');

    printf("=== Pascal lower matrix ===\n");
    pascal_low(mat, n);
    for (i = 0; i < n; i++)
        for (j = 0; j < n; j++)
            printf("%4d%c", mat[i][j], j < n - 1 ? ' ' : '\n');

    printf("=== Pascal symmetric matrix ===\n");
    pascal_sym(mat, n);
    for (i = 0; i < n; i++)
        for (j = 0; j < n; j++)
            printf("%4d%c", mat[i][j], j < n - 1 ? ' ' : '\n');

    return 0;
}
