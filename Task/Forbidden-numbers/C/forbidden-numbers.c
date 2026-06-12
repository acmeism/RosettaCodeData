#include <stdio.h>
#include <stdbool.h>
#include <math.h>
#include <locale.h>

bool isForbidden(int n) {
    int m = n, v = 0, p;
    while (m > 1 && !(m % 4)) {
        m /= 4;
        ++v;
    }
    p = (int)pow(4.0, (double)v);
    return n / p % 8 == 7;
}

int main() {
    int i = 0, count = 0, limit = 500;
    printf("The first 50 forbidden numbers are:\n");
    for ( ; count < 50; ++i) {
        if (isForbidden(i)) {
            printf("%3d ", i);
            ++count;
            if (!(count+1)%10) printf("\n");
        }
    }
    printf("\n\n");
    setlocale(LC_NUMERIC, "");
    for (i = 1, count = 0; ; ++i) {
        if (isForbidden(i)) ++count;
        if (i == limit) {
            printf("Forbidden number count <= %'11d: %'10d\n", limit, count);
            if (limit == 500000000) break;
            limit *= 10;
        }
    }
    return 0;
}
