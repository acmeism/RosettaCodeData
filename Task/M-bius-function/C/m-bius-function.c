#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    const int MU_MAX = 1000000;
    int i, j;
    int *mu;
    int sqroot;

    sqroot = (int)sqrt(MU_MAX);

    mu = malloc((MU_MAX + 1) * sizeof(int));

    for (i = 0; i < MU_MAX;i++) {
        mu[i] = 1;
    }

    for (i = 2; i <= sqroot; i++) {
        if (mu[i] == 1) {
            // for each factor found, swap + and -
            for (j = i; j <= MU_MAX; j += i) {
                mu[j] *= -i;
            }
            // square factor = 0
            for (j = i * i; j <= MU_MAX; j += i * i) {
                mu[j] = 0;
            }
        }
    }

    for (i = 2; i <= MU_MAX; i++) {
        if (mu[i] == i) {
            mu[i] = 1;
        } else if (mu[i] == -i) {
            mu[i] = -1;
        } else if (mu[i] < 0) {
            mu[i] = 1;
        } else if (mu[i] > 0) {
            mu[i] = -1;
        }
    }

    printf("First 199 terms of the möbius function are as follows:\n    ");
    for (i = 1; i < 200; i++) {
        printf("%2d  ", mu[i]);
        if ((i + 1) % 20 == 0) {
            printf("\n");
        }
    }

    free(mu);
    return 0;
}
