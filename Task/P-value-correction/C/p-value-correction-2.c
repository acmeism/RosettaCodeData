#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define SIZE 50
#define each_i(start, end) for (i = start; i < end; ++i)

typedef enum { UP, DOWN } direction;

typedef struct { int index; double value; } iv1;

typedef struct { int index; int value; } iv2;

/* test also for 'Unknown' correction type */
const char *types[8] = {
    "Benjamini-Hochberg", "Benjamini-Yekutieli", "Bonferroni", "Hochberg",
    "Holm", "Hommel", "Šidák", "Unknown"
};

int compare_iv1(const void *a, const void *b) {
    double aa = ((iv1 *)a) -> value;
    double bb = ((iv1 *)b) -> value;
    if (aa > bb) return 1;
    if (aa < bb) return -1;
    return 0;
}

int compare_iv1_desc(const void *a, const void *b) {
    return -compare_iv1(a, b);
}

int compare_iv2(const void *a, const void *b) {
    return ((iv2 *)a) -> value - ((iv2 *)b) -> value;
}

void ratchet(double *pa, direction dir) {
    int i;
    double m = pa[0];
    if (dir == UP) {
        each_i(1, SIZE) {
            if (pa[i] > m) pa[i] = m;
            m = pa[i];
        }
    }
    else {
        each_i(1, SIZE) {
            if (pa[i] < m) pa[i] = m;
            m = pa[i];
        }
    }
    each_i(0, SIZE) if (pa[i] > 1.0) pa[i] = 1.0;
}

void schwartzian(const double *p, double *pa, direction dir) {
    int i;
    int order[SIZE];
    int order2[SIZE];
    iv1 iv1s[SIZE];
    iv2 iv2s[SIZE];
    double pa2[SIZE];
    each_i(0, SIZE) { iv1s[i].index = i; iv1s[i].value = p[i]; }
    if (dir == UP)
        qsort(iv1s, SIZE, sizeof(iv1s[0]), compare_iv1_desc);
    else
        qsort(iv1s, SIZE, sizeof(iv1s[0]), compare_iv1);
    each_i(0, SIZE) order[i] = iv1s[i].index;
    each_i(0, SIZE) pa[i] *= p[order[i]];
    ratchet(pa, dir);
    each_i(0, SIZE) { iv2s[i].index = i; iv2s[i].value = order[i]; }
    qsort(iv2s, SIZE, sizeof(iv2s[0]), compare_iv2);
    each_i(0, SIZE) order2[i] = iv2s[i].index;
    each_i(0, SIZE) pa2[i] = pa[order2[i]];
    each_i(0, SIZE) pa[i] = pa2[i];
}

void adjust(const double *p, double *pa, const char *type) {
    int i;
    if (!strcmp(type, "Benjamini-Hochberg")) {
        each_i(0, SIZE) pa[i] = (double)SIZE / (SIZE - i);
        schwartzian(p, pa, UP);
    }
    else if (!strcmp(type, "Benjamini-Yekutieli")) {
        double q = 0.0;
        each_i(1, SIZE + 1) q += 1.0 / i;
        each_i(0, SIZE) pa[i] = q * SIZE / (SIZE - i);
        schwartzian(p, pa, UP);
    }
    else if (!strcmp(type, "Bonferroni")) {
        each_i(0, SIZE) pa[i] = (p[i] * SIZE > 1.0) ? 1.0 : p[i] * SIZE;
    }
    else if (!strcmp(type, "Hochberg")) {
        each_i(0, SIZE) pa[i]  = i + 1.0;
        schwartzian(p, pa, UP);
    }
    else if (!strcmp(type, "Holm")) {
        each_i(0, SIZE) pa[i] = SIZE - i;
        schwartzian(p, pa, DOWN);
    }
    else if (!strcmp(type, "Hommel")) {
        int i, j;
        int order[SIZE];
        int order2[SIZE];
        iv1 iv1s[SIZE];
        iv2 iv2s[SIZE];
        double s[SIZE];
        double q[SIZE];
        double pa2[SIZE];
        int indices[SIZE];
        each_i(0, SIZE) { iv1s[i].index = i; iv1s[i].value = p[i]; }
        qsort(iv1s, SIZE, sizeof(iv1s[0]), compare_iv1);
        each_i(0, SIZE) order[i] = iv1s[i].index;
        each_i(0, SIZE) s[i] = p[order[i]];
        double min = s[0] * SIZE;
        each_i(1, SIZE) {
            double temp = s[i] / (i + 1.0);
            if (temp < min) min = temp;
        }
        each_i(0, SIZE) q[i] = min;
        each_i(0, SIZE) pa2[i] = min;
        for (j = SIZE - 1; j >= 2; --j) {
            each_i(0, SIZE) indices[i] = i;
            int upper_start = SIZE - j + 1;      /* upper indices start index */
            int upper_size = j - 1;              /* size of upper indices */
            int lower_size = SIZE - upper_size;  /* size of lower indices */
            double qmin = j * s[indices[upper_start]] / 2.0;
            each_i(1, upper_size) {
                double temp = s[indices[upper_start + i]] * j / (2.0 + i);
                if (temp < qmin) qmin = temp;
            }
            each_i(0, lower_size) {
                double temp = s[indices[i]] * j;
                q[indices[i]] = (temp < qmin) ? temp : qmin;
            }
            each_i(0, upper_size) q[indices[upper_start + i]] = q[SIZE - j];
            each_i(0, SIZE) if (pa2[i] < q[i]) pa2[i] = q[i];
        }
        each_i(0, SIZE) { iv2s[i].index = i; iv2s[i].value = order[i]; }
        qsort(iv2s, SIZE, sizeof(iv2s[0]), compare_iv2);
        each_i(0, SIZE) order2[i] = iv2s[i].index;
        each_i(0, SIZE) pa[i] = pa2[order2[i]];
    }
    else if (!strcmp(type, "Šidák")) {
        each_i(0, SIZE) pa[i] = 1.0 - pow(1.0 - p[i], SIZE);
    }
    else {
        printf("\nSorry, do not know how to do '%s' correction.\n", type);
        printf("Perhaps you want one of these?:\n");
        each_i(0, 7) printf("  %s\n", types[i]);
        exit(1);
    }
}

void adjusted(const double *p, const char *type) {
    int i;
    double pa[SIZE] = { 0.0 };
    if (check(p)) {
        adjust(p, pa, type);
        printf("\n%s", type);
        each_i(0, SIZE) {
            if (!(i % 5)) printf("\n[%2d]  ", i);
            printf("%1.10f ", pa[i]);
        }
        printf("\n");
    }
    else {
        printf("p-values must be in range 0.0 to 1.0\n");
        exit(1);
    }
}

int check(const double* p) {
    int i;
    each_i(0, SIZE) {
        if (p[i] < 0.0 || p[i] > 1.0) return 0;
    }
    return 1;
}

int main() {
    int i;
    double p_values[SIZE] = {
        4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
        8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
        4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
        8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
        3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
        1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
        4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
        3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
        1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
        2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03
    };
    each_i(0, 8) adjusted(p_values, types[i]);
    return 0;
}
