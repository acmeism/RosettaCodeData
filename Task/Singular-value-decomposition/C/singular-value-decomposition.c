#include <stdio.h>
#include <gsl/gsl_linalg.h>

/* Custom function for printing a gsl_matrix in matrix form. */
void gsl_matrix_print(const gsl_matrix *M) {
    int rows = M->size1;
    int cols = M->size2;
    for (int i = 0; i < rows; i++) {
        printf("|");
        for (int j = 0; j < cols; j++) {
            printf("% 12.10f ", gsl_matrix_get(M, i, j));
        }
        printf("\b|\n");
    }
    printf("\n");
}

int main(){
    double a[] = {3, 0, 4, 5};
    gsl_matrix_view A = gsl_matrix_view_array(a, 2, 2);
    gsl_matrix *V = gsl_matrix_alloc(2, 2);
    gsl_vector *S = gsl_vector_alloc(2);
    gsl_vector *work = gsl_vector_alloc(2);

    /* V is returned here in untransposed form. */
    gsl_linalg_SV_decomp(&A.matrix, V, S, work);
    gsl_matrix_transpose(V);
    double s[] = {S->data[0], 0, 0, S->data[1]};
    gsl_matrix_view SM = gsl_matrix_view_array(s, 2, 2);

    printf("U:\n");
    gsl_matrix_print(&A.matrix);

    printf("S:\n");
    gsl_matrix_print(&SM.matrix);

    printf("VT:\n");
    gsl_matrix_print(V);

    gsl_matrix_free(V);
    gsl_vector_free(S);
    gsl_vector_free(work);
    return 0;
}
