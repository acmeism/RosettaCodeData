#include <assert.h>
#include <complex.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>

complex clean(complex x) {
    const double epsilon = 1e-14;
    double r = creal(x);
    double i = cimag(x);
    double rr = round(r);
    double ri = round(i);
    if (fabs(r - rr) < epsilon)
        r = rr;
    if (fabs(i - ri) < epsilon)
        i = ri;
    return CMPLX(r, i);
}

void dft(const complex* in, complex* out, size_t n, bool inverse) {
    assert(n != 0);
    double f = 2.0 * M_PI / n;
    if (!inverse)
        f = -f;
    for (size_t i = 0; i < n; ++i) {
        complex sum = 0;
        for (size_t j = 0; j < n; ++j) {
            double x = f * i * j;
            sum += in[j] * CMPLX(cos(x), sin(x));
        }
        if (inverse)
            sum /= n;
        out[i] = clean(sum);
    }
}

void print_complex(complex x) {
    double r = creal(x);
    double i = cimag(x);
    if (i == 0)
        printf("%f", r);
    else if (i > 0)
        printf("%f+%fi", r, i);
    else
        printf("%f%fi", r, i);
}

void print_complex_array(const complex* a, size_t n) {
    printf("[");
    for (size_t i = 0; i < n; ++i) {
        if (i != 0)
            printf(", ");
        print_complex(a[i]);
    }
    printf("]");
}

int main() {
    complex in[] = {2.0, 3.0, 5.0, 7.0, 11.0};
    const size_t n = sizeof(in) / sizeof(in[0]);
    complex out[n];

    printf("Input array:\n");
    print_complex_array(in, n);

    dft(in, out, n, false);

    printf("\n\nDiscrete Fourier Transform:\n");
    print_complex_array(out, n);

    dft(out, in, n, true);

    printf("\n\nInverse DFT:\n");
    print_complex_array(in, n);

    printf("\n");
    return 0;
}
