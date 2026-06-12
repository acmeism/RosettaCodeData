#include <stdio.h>
#include <stdlib.h>

typedef int(*I2I)(int);
typedef struct {
    int a, b;
} Pair;

Pair brent(I2I f, int x0) {
    int power = 1, lam = 1, tortoise = x0, hare, mu, i;
    Pair result;

    hare = (*f)(x0);
    while (tortoise != hare) {
        if (power == lam) {
            tortoise = hare;
            power = power * 2;
            lam = 0;
        }
        hare = (*f)(hare);
        lam++;
    }

    hare = x0;
    i = 0;
    while (i < lam) {
        hare = (*f)(hare);
        i++;
    }

    tortoise = x0;
    mu = 0;
    while (tortoise != hare) {
        tortoise = (*f)(tortoise);
        hare = (*f)(hare);
        mu++;
    }

    result.a = lam;
    result.b = mu;
    return result;
}

int lambda(int x) {
    return (x*x + 1) % 255;
}

int main() {
    int x0 = 3, x = 3, i;
    Pair result;

    printf("[3");
    for (i = 1; i <= 40; ++i) {
        x = lambda(x);
        printf(", %d", x);
    }
    printf("]\n");

    result = brent(lambda, x0);
    printf("Cycle length = %d\nStart index = %d\nCycle = [", result.a, result.b);

    x0 = 3;
    x = x0;
    for (i = 1; i <= result.b; ++i) {
        x = lambda(x);
    }
    for (i = 1; i <= result.a; ++i) {
        if (i > 1) {
            printf(", ");
        }

        printf("%d", x);
        x = lambda(x);
    }

    printf("]\n");

    return 0;
}
