#include <stdio.h>
#include <locale.h>

int divisorCount(int n) {
    int i, j, count = 0, k = !(n%2) ? 1 : 2;
    for (i = 1; i*i <= n; i += k) {
        if (!(n%i)) {
            ++count;
            j = n/i;
            if (j != i) ++count;
        }
    }
    return count;
}

int main() {
    int i, numbers50[50], count = 0, n = 1, dc;
    printf("First 50 numbers which are the cube roots of the products of their proper divisors:\n");
    setlocale(LC_NUMERIC, "");
    while (1) {
        dc = divisorCount(n);
        if (n == 1|| dc == 8) {
            ++count;
            if (count <= 50) {
                numbers50[count-1] = n;
                if (count == 50) {
                    for (i = 0; i < 50; ++i) {
                        printf("%3d ", numbers50[i]);
                        if (!((i+1) % 10)) printf("\n");
                    }
                }
            } else if (count == 500) {
                printf("\n500th   : %'d\n", n);
            } else if (count == 5000) {
                printf("5,000th : %'d\n", n);
            } else if (count == 50000) {
                printf("50,000th: %'d\n", n);
                break;
            }
        }
        ++n;
    }
    return 0;
}
