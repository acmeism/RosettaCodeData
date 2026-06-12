#include <stdio.h>

static int p[19] = {0, 0, 1, 1, 0, 1, 0, 1, 0, 0,
                    0, 1, 0, 1, 0, 0, 0, 1, 0};

int isstrange(long n) {
    if (n < 10) return 0;
    for (; n >= 10; n /= 10) {
        if (!p[n%10 + (n/10)%10]) return 0;
    }
    return 1;
}

int main(void) {
    long n;
    int k = 0;

    for (n = 101; n < 500; n++) {
        if (isstrange(n)) {
            printf("%d%c", n, ++k%10 ? ' ' : '\n');
        }
    }
    return 0;
}
