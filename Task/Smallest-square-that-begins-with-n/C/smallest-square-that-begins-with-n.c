#include <stdio.h>

void f(int n) {
    int i = 1;
    if (n < 1) {
        return;
    }
    while (1) {
        int sq = i * i;
        while (sq > n) {
            sq /= 10;
        }
        if (sq == n) {
            printf("%3d %9d %4d\n", n, i * i, i);
            return;
        }
        i++;
    }
}

int main() {
    int i;

    printf("Prefix    n^2    n\n");
    printf("");
    for (i = 1; i < 50; i++) {
        f(i);
    }

    return 0;
}
