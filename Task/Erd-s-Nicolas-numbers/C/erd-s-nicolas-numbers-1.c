#include <stdio.h>
#include <stdlib.h>

int main() {
    const int maxNumber = 100000000;
    int *dsum = (int *)malloc((maxNumber + 1) * sizeof(int));
    int *dcount = (int *)malloc((maxNumber + 1) * sizeof(int));
    int i, j;
    for (i = 0; i <= maxNumber; ++i) {
        dsum[i] = 1;
        dcount[i] = 1;
    }
    for (i = 2; i <= maxNumber; ++i) {
        for (j = i + i; j <= maxNumber; j += i) {
            if (dsum[j] == j) {
                printf("%8d equals the sum of its first %d divisors\n", j, dcount[j]);
            }
            dsum[j] += i;
            ++dcount[j];
        }
    }
    free(dsum);
    free(dcount);
    return 0;
}
