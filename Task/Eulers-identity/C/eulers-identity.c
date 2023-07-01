#include <stdio.h>
#include <math.h>
#include <complex.h>
#include <wchar.h>
#include <locale.h>

int main() {
    wchar_t pi = L'\u03c0'; /* Small pi symbol */
    wchar_t ae = L'\u2245'; /* Approximately equals symbol */
    double complex e = cexp(M_PI * I) + 1.0;
    setlocale(LC_CTYPE, "");
    printf("e ^ %lci + 1 = [%.16f, %.16f] %lc 0\n", pi, creal(e), cimag(e), ae);
    return 0;
}
