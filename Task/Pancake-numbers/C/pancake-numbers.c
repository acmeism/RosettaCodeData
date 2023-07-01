#include <stdio.h>

int pancake(int n) {
    int gap = 2, sum = 2, adj = -1;
    while (sum < n) {
        adj++;
        gap = gap * 2 - 1;
        sum += gap;
    }
    return n + adj;
}

int main() {
    int i, j;
    for (i = 0; i < 4; i++) {
        for (j = 1; j < 6; j++) {
            int n = i * 5 + j;
            printf("p(%2d) = %2d  ", n, pancake(n));
        }
        printf("\n");
    }
    return 0;
}
