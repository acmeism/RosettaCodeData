#include <stdio.h>

int main() {
    int i = 1, c = 0, res[7];
    unsigned long long j;
    while (c < 7) {
        j = i;
        while (j != 1) {
            if (j % 2 == 0) j /= 2; else j = 3 * j + 1;
            if (j % i == 0) {
                res[c++] = i;
                break;
            }
        }
        i += 2;
    }
    for (c = 0; c < 7; ++c) {
        printf("%d ", res[c]);
    }
    printf("\n");
    return 0;
}
