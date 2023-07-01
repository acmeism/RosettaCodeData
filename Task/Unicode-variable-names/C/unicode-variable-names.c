// Works for clang and GCC 10+
#include<stdio.h>

int main() {
    int Δ = 1;      // if unsupported, use \u0394
    Δ++;
    printf("%d",Δ);
    return 0;
}
