#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int binomial(int n, int k) {
    int num, denom, i;

    if (n < 0 || k < 0 || n < k) return -1;
    if (n == 0 || k == 0) return 1;

    num = 1;
    for (i = k + 1; i <= n; ++i) {
        num = num * i;
    }

    denom = 1;
    for (i = 2; i <= n - k; ++i) {
        denom *= i;
    }

    return num / denom;
}

int gcd(int a, int b) {
    int temp;
    while (b != 0) {
        temp = a % b;
        a = b;
        b = temp;
    }
    return a;
}

typedef struct tFrac {
    int num, denom;
} Frac;

Frac makeFrac(int n, int d) {
    Frac result;
    int g;

    if (d == 0) {
        result.num = 0;
        result.denom = 0;
        return result;
    }

    if (n == 0) {
        d = 1;
    } else if (d < 0) {
        n = -n;
        d = -d;
    }

    g = abs(gcd(n, d));
    if (g > 1) {
        n = n / g;
        d = d / g;
    }

    result.num = n;
    result.denom = d;
    return result;
}

Frac negateFrac(Frac f) {
    return makeFrac(-f.num, f.denom);
}

Frac subFrac(Frac lhs, Frac rhs) {
    return makeFrac(lhs.num * rhs.denom - lhs.denom * rhs.num, rhs.denom * lhs.denom);
}

Frac multFrac(Frac lhs, Frac rhs) {
    return makeFrac(lhs.num * rhs.num, lhs.denom * rhs.denom);
}

bool equalFrac(Frac lhs, Frac rhs) {
    return (lhs.num == rhs.num) && (lhs.denom == rhs.denom);
}

bool lessFrac(Frac lhs, Frac rhs) {
    return (lhs.num * rhs.denom) < (rhs.num * lhs.denom);
}

void printFrac(Frac f) {
    printf("%d", f.num);
    if (f.denom != 1) {
        printf("/%d", f.denom);
    }
}

Frac bernoulli(int n) {
    Frac a[16];
    int j, m;

    if (n < 0) {
        a[0].num = 0;
        a[0].denom = 0;
        return a[0];
    }

    for (m = 0; m <= n; ++m) {
        a[m] = makeFrac(1, m + 1);
        for (j = m; j >= 1; --j) {
            a[j - 1] = multFrac(subFrac(a[j - 1], a[j]), makeFrac(j, 1));
        }
    }

    if (n != 1) {
        return a[0];
    }

    return negateFrac(a[0]);
}

void faulhaber(int p) {
    Frac coeff, q;
    int j, pwr, sign;

    printf("%d : ", p);
    q = makeFrac(1, p + 1);
    sign = -1;
    for (j = 0; j <= p; ++j) {
        sign = -1 * sign;
        coeff = multFrac(multFrac(multFrac(q, makeFrac(sign, 1)), makeFrac(binomial(p + 1, j), 1)), bernoulli(j));
        if (equalFrac(coeff, makeFrac(0, 1))) {
            continue;
        }
        if (j == 0) {
            if (!equalFrac(coeff, makeFrac(1, 1))) {
                if (equalFrac(coeff, makeFrac(-1, 1))) {
                    printf("-");
                } else {
                    printFrac(coeff);
                }
            }
        } else {
            if (equalFrac(coeff, makeFrac(1, 1))) {
                printf(" + ");
            } else if (equalFrac(coeff, makeFrac(-1, 1))) {
                printf(" - ");
            } else if (lessFrac(makeFrac(0, 1), coeff)) {
                printf(" + ");
                printFrac(coeff);
            } else {
                printf(" - ");
                printFrac(negateFrac(coeff));
            }
        }
        pwr = p + 1 - j;
        if (pwr > 1) {
            printf("n^%d", pwr);
        } else {
            printf("n");
        }
    }
    printf("\n");
}

int main() {
    int i;

    for (i = 0; i < 10; ++i) {
        faulhaber(i);
    }

    return 0;
}
