#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int compareInts(const void *i1, const void *i2) {
    int a = *((int *)i1);
    int b = *((int *)i2);
    return a - b;
}

int main() {
    int i, j, nsum, vsum, vcount, values[6], numbers[4];
    srand(time(NULL));
    for (;;) {
        vsum = 0;
        for (i = 0; i < 6; ++i) {
            for (j = 0; j < 4; ++j) {
                numbers[j] = 1 + rand() % 6;
            }
            qsort(numbers, 4, sizeof(int), compareInts);
            nsum = 0;
            for (j = 1; j < 4; ++j) {
                nsum += numbers[j];
            }
            values[i] = nsum;
            vsum += values[i];
        }
        if (vsum < 75) continue;
        vcount = 0;
        for (j = 0; j < 6; ++j) {
            if (values[j] >= 15) vcount++;
        }
        if (vcount < 2) continue;
        printf("The 6 random numbers generated are:\n");
        printf("[");
        for (j = 0; j < 6; ++j) printf("%d ", values[j]);
        printf("\b]\n");
        printf("\nTheir sum is %d and %d of them are >= 15\n", vsum, vcount);
        break;
    }
    return 0;
}
