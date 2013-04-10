#include <stdio.h>

constexpr int factorial(int n) {
    return n ? (n * factorial(n - 1)) : 1;
}

constexpr int f10 = factorial(10);

int main() {
    printf("%d\n", f10);
    return 0;
}
