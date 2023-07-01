#include <math.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int n;
    double **elems;
} SquareMatrix;

SquareMatrix init_square_matrix(int n, double elems[n][n]) {
    SquareMatrix A = {
        .n = n,
        .elems = malloc(n * sizeof(double *))
    };
    for(int i = 0; i < n; ++i) {
        A.elems[i] = malloc(n * sizeof(double));
        for(int j = 0; j < n; ++j)
            A.elems[i][j] = elems[i][j];
    }

    return A;
}

SquareMatrix copy_square_matrix(SquareMatrix src) {
    SquareMatrix dest;
    dest.n = src.n;
    dest.elems = malloc(dest.n * sizeof(double *));
    for(int i = 0; i < dest.n; ++i) {
        dest.elems[i] = malloc(dest.n * sizeof(double));
        for(int j = 0; j < dest.n; ++j)
            dest.elems[i][j] = src.elems[i][j];
    }

    return dest;
}

double det(SquareMatrix A) {
    double det = 1;

    for(int j = 0; j < A.n; ++j) {
        int i_max = j;
        for(int i = j; i < A.n; ++i)
            if(A.elems[i][j] > A.elems[i_max][j])
                i_max = i;

        if(i_max != j) {
            for(int k = 0; k < A.n; ++k) {
                double tmp = A.elems[i_max][k];
                A.elems[i_max][k] = A.elems[j][k];
                A.elems[j][k]     = tmp;
            }

            det *= -1;
        }

        if(abs(A.elems[j][j]) < 1e-12) {
            puts("Singular matrix!");
            return NAN;
        }

        for(int i = j + 1; i < A.n; ++i) {
            double mult = -A.elems[i][j] / A.elems[j][j];
            for(int k = 0; k < A.n; ++k)
                A.elems[i][k] += mult * A.elems[j][k];
        }
    }

    for(int i = 0; i < A.n; ++i)
        det *= A.elems[i][i];

    return det;
}

void deinit_square_matrix(SquareMatrix A) {
    for(int i = 0; i < A.n; ++i)
        free(A.elems[i]);
    free(A.elems);
}

double cramer_solve(SquareMatrix A, double det_A, double *b, int var) {
    SquareMatrix tmp = copy_square_matrix(A);
    for(int i = 0; i < tmp.n; ++i)
        tmp.elems[i][var] = b[i];

    double det_tmp = det(tmp);
    deinit_square_matrix(tmp);

    return det_tmp / det_A;
}

int main(int argc, char **argv) {
#define N 4
    double elems[N][N] = {
        { 2, -1,  5,  1},
        { 3,  2,  2, -6},
        { 1,  3,  3, -1},
        { 5, -2, -3,  3}
    };
    SquareMatrix A = init_square_matrix(N, elems);

    SquareMatrix tmp = copy_square_matrix(A);
    int det_A = det(tmp);
    deinit_square_matrix(tmp);

    double b[] = {-3, -32, -47, 49};

    for(int i = 0; i < N; ++i)
        printf("%7.3lf\n", cramer_solve(A, det_A, b, i));

    deinit_square_matrix(A);
    return EXIT_SUCCESS;
}
