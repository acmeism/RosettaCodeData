#include "stdio.h"
#include "math.h"

int perfect(int n) {
    int max = (int)sqrt((double)n) + 1;
    int tot = 1;
    int i;

    for (i = 2; i < max; i++)
        if ( (n % i) == 0 ) {
            tot += i;
            int q = n / i;
            if (q > i)
                tot += q;
        }

    return tot == n;
}

int main() {
    int n;
    for (n = 2; n < 33550337; n++)
        if (perfect(n))
            printf("%d\n", n);

    return 0;
}
