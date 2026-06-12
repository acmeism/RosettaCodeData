#include <stdio.h>

void hollowMatrix(unsigned int n) {
    int i, j;
    for (i = 0; i < n; ++i) {
        for (j = 0; j < n; ++j) {
            if (i == 0 || i == n - 1 || j == 0 || j == n - 1) {
                printf("%d ", 1);
            } else {
                printf("%d ", 0);
            }
        }
        printf("\n");
    }
}

int main() {
    hollowMatrix(10);
    printf("\n");
    hollowMatrix(11);
    return 0;
}
