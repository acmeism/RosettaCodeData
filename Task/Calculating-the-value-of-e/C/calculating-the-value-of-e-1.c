#include <stdio.h>
#include <math.h>

int main(void)
{
    double e;

    puts("The double precision in C give about 15 significant digits.\n"
         "Values below are presented with 16 digits after the decimal point.\n");

    // The most direct way to compute Euler constant.
    //
    e = exp(1);
    printf("Euler constant e = %.16lf\n", e);

    // The fast and independed method: e = lim (1 + 1/n)**n
    //
    e = 1.0 + 0x1p-26;
    for (int i = 0; i < 26; i++)
        e *= e;
    printf("Euler constant e = %.16lf\n", e);

    // Taylor expansion e = 1 + 1/1 + 1/2 + 1/2/3 + 1/2/3/4 + 1/2/3/4/5 + ...
    // Actually Kahan summation may improve the accuracy, but is not necessary.
    //
    const int N = 1000;
    double a[1000];
    a[0] = 1.0;
    for (int i = 1; i < N; i++)
    {
        a[i] = a[i-1] / i;
    }
    e = 1.;
    for (int i = N - 1; i > 0; i--)
        e += a[i];
    printf("Euler constant e = %.16lf\n", e);

    return 0;
}
