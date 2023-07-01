#include <stdio.h>
#include <math.h>

int main() {
    int n = 1, count = 0, sq, cr;
    for ( ; count < 30; ++n) {
        sq = n * n;
        cr = (int)cbrt((double)sq);
        if (cr * cr * cr != sq) {
            count++;
            printf("%d\n", sq);
        }
        else {
            printf("%d is square and cube\n", sq);
        }
    }
    return 0;
}
