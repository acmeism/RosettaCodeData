#include <stdio.h>
#include <stdbool.h>
#include <locale.h>

int inc[8] = {4, 2, 4, 2, 4, 6, 2, 6};

bool isPrime(int n) {
    if (n < 2) return false;
    if (n%2 == 0) return n == 2;
    if (n%3 == 0) return n == 3;
    int d = 5;
    while (d*d <= n) {
        if (n%d == 0) return false;
        d += 2;
        if (n%d == 0) return false;
        d += 4;
    }
    return true;
}

// Assumes n is odd.
int firstPrimeFactor(int n) {
    if (n == 1) return 1;
    if (!(n%3)) return 3;
    if (!(n%5)) return 5;
    for (int k = 7, i = 0; k*k <= n; ) {
        if (!(n%k)) {
            return k;
        } else {
            k += inc[i];
            i = (i + 1) % 8;
        }
    }
    return n;
}

int main() {
    int i = 1, j, bc = 0, p, q;
    int blum[50], counts[4] = {0}, digits[4] = {1, 3, 5, 7};
    setlocale(LC_NUMERIC, "");
    while (true) {
        p = firstPrimeFactor(i);
        if (p % 4 == 3) {
            q = i / p;
            if (q != p && q % 4 == 3 && isPrime(q)) {
                if (bc < 50) blum[bc] = i;
                ++counts[i % 10 / 3];
                ++bc;
                if (bc == 50) {
                    printf("First 50 Blum integers:\n");
                    for (j = 0; j < 50; ++j) {
                        printf("%3d ", blum[j]);
                        if (!((j+1) % 10)) printf("\n");
                    }
                    printf("\n");
                } else if (bc == 26828 || !(bc % 100000)) {
                    printf("The %'7dth Blum integer is: %'9d\n", bc, i);
                    if (bc == 400000) {
                        printf("\n%% distribution of the first 400,000 Blum integers:\n");
                        for (j = 0; j < 4; ++j) {
                            printf("  %6.3f%% end in %d\n", counts[j]/4000.0, digits[j]);
                        }
                        break;
                    }
                }
            }
        }
        i += (i % 5 == 3) ? 4 : 2;
    }
    return 0;
}
