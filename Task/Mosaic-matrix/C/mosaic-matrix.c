#include <stdio.h>

void mosaicMatrix(unsigned int n) {
    int i, j;
    for (i = 0; i < n; ++i) {
        for (j = 0; j < n; ++j) {
            if ((i + j) % 2 == 0) {
                printf("%s ", "1");
            } else {
                printf("%s ", "0");
            }
        }
        printf("\n");
    }
}

int main() {
    mosaicMatrix(10);
    printf("\n");
    mosaicMatrix(11);
    return 0;
}
