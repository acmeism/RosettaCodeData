#include <stdio.h>

int min(int a, int b) {
    if (a < b) return a;
    return b;
}

int main() {
    int n;
    int numbers1[5] = {5, 45, 23, 21, 67};
    int numbers2[5] = {43, 22, 78, 46, 38};
    int numbers3[5] = {9, 98, 12, 98, 53};
    int numbers[5]  = {};
    for (n = 0; n < 5; ++n) {
        numbers[n] = min(min(numbers1[n], numbers2[n]), numbers3[n]);
        printf("%d ", numbers[n]);
    }
    printf("\n");
    return 0;
}
