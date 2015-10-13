#include <gsl/gsl_poly.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    /* 0 + 2x - 3x^2 + 1x^3 */
    double p[] = {0, 2, -3, 1};
    double z[6];
    gsl_poly_complex_workspace *w = gsl_poly_complex_workspace_alloc(4);
    gsl_poly_complex_solve(p, 4, w, z);
    gsl_poly_complex_workspace_free(w);

    for(int i = 0; i < 3; ++i)
        printf("%.12f\n", z[2 * i]);

    return 0;
}
