#include <stdio.h>

void vc(int n, int base, int *num, int *denom)
{
        int p = 0, q = 1;

        while (n) {
                p = p * base + (n % base);
                q *= base;
                n /= base;
        }

        *num = p;
        *denom = q;

        while (p) { n = p; p = q % p; q = n; }
        *num /= q;
        *denom /= q;
}

int main()
{
        int d, n, i, b;
        for (b = 2; b < 6; b++) {
                printf("base %d:", b);
                for (i = 0; i < 10; i++) {
                        vc(i, b, &n, &d);
                        if (n) printf("  %d/%d", n, d);
                        else   printf("  0");
                }
                printf("\n");
        }

        return 0;
}
