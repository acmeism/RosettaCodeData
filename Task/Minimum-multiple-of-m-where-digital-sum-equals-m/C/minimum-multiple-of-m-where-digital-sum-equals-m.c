#include <stdio.h>

unsigned digit_sum(unsigned n) {
    unsigned sum = 0;
    do { sum += n % 10; }
    while(n /= 10);
    return sum;
}

unsigned a131382(unsigned n) {
    unsigned m;
    for (m = 1; n != digit_sum(m*n); m++);
    return m;
}

int main() {
    unsigned n;
    for (n = 1; n <= 70; n++) {
        printf("%9u", a131382(n));
        if (n % 10 == 0) printf("\n");
    }
    return 0;
}
