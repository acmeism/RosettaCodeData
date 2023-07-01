#include <stdio.h>
#include <stdlib.h>

double median(double *x, int start, int end_inclusive) {
    int size = end_inclusive - start + 1;
    if (size <= 0) {
        printf("Array slice cannot be empty\n");
        exit(1);
    }
    int m = start + size / 2;
    if (size % 2) return x[m];
    return (x[m - 1] + x[m]) / 2.0;
}

int compare (const void *a, const void *b) {
    double aa = *(double*)a;
    double bb = *(double*)b;
    if (aa > bb) return 1;
    if (aa < bb) return -1;
    return 0;
}

int fivenum(double *x, double *result, int x_len) {
    int i, m, lower_end;
    for (i = 0; i < x_len; i++) {
        if (x[i] != x[i]) {
           printf("Unable to deal with arrays containing NaN\n\n");
           return 1;
        }
    }
    qsort(x, x_len, sizeof(double), compare);
    result[0] = x[0];
    result[2] = median(x, 0, x_len - 1);
    result[4] = x[x_len - 1];
    m = x_len / 2;
    lower_end = (x_len % 2) ? m : m - 1;
    result[1] = median(x, 0, lower_end);
    result[3] = median(x, m, x_len - 1);
    return 0;
}

int show(double *result, int places) {
    int i;
    char f[7];
    sprintf(f, "%%.%dlf", places);
    printf("[");
    for (i = 0; i < 5; i++) {
        printf(f, result[i]);
        if (i < 4) printf(", ");
    }
    printf("]\n\n");
}

int main() {
    double result[5];

    double x1[11] = {15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0};
    if (!fivenum(x1, result, 11)) show(result, 1);

    double x2[6] = {36.0, 40.0, 7.0, 39.0, 41.0, 15.0};
    if (!fivenum(x2, result, 6)) show(result, 1);

    double x3[20] = {
         0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,  0.73438555,
        -0.03035726,  1.46675970, -0.74621349, -0.72588772,  0.63905160,  0.61501527,
        -0.98983780, -1.00447874, -0.62759469,  0.66206163,  1.04312009, -0.10305385,
         0.75775634,  0.32566578
    };
    if (!fivenum(x3, result, 20)) show(result, 9);

    return 0;
}
