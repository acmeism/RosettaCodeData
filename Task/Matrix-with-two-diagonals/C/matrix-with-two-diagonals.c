#include <stdio.h>

void specialMatrix(unsigned int n) {
    int i, j;
    for (i = 0; i < n; ++i) {
        for (j = 0; j < n; ++j) {
            if (i == j || i + j == n - 1) {
                printf("%d ", 1);
            } else {
                printf("%d ", 0);
            }
        }
        printf("\n");
    }
}

int main() {
    specialMatrix(10); // even n
    printf("\n");
    specialMatrix(11); // odd n
    return 0;
}
