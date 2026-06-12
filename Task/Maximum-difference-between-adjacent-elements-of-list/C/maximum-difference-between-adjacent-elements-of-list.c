#include <stdio.h>
#include <math.h>

typedef struct {
    double x;
    double y;
} pair;

int main() {
    double list[17] = {1, 8, 2, -3, 0, 1, 1, -2.3, 0, 5.5, 8,6, 2, 9, 11, 10, 3};
    double diff, maxDiff = -1;
    pair maxPairs[5];
    int i, count = 0;
    for (i = 1; i < 17; ++i) {
        diff = fabs(list[i-1] - list[i]);
        if (diff > maxDiff) {
            maxDiff = diff;
            count = 0;
            maxPairs[count++] = (pair){list[i-1], list[i]};
        } else if (diff == maxDiff) {
            maxPairs[count++] = (pair){list[i-1], list[i]};
        }
    }
    printf("The maximum difference between adjacent pairs of the list is: %g\n", maxDiff);
    printf("The pairs with this difference are: ");
    for (i = 0; i < count; ++i) printf("[%g, %g] ", maxPairs[i].x, maxPairs[i].y);
    printf("\n");
    return 0;
}
