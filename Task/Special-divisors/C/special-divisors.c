#include <stdbool.h>
#include <stdio.h>

int reverse(int n) {
    int result = 0;
    while (n > 0) {
        result = 10 * result + n % 10;
        n /= 10;
    }
    return result;
}

int main() {
    const int limit1 = 200;

    int row = 0;
    int num = 0;
    int n;

    for (n = 1; n < limit1; n++) {
        bool flag = true;
        int revNum = reverse(n);
        int m;

        for (m = 1; m < n / 2; m++) {
            int revDiv = reverse(m);
            if (n % m == 0) {
                if (revNum % revDiv == 0) {
                    flag = true;
                } else {
                    flag = false;
                    break;
                }
            }
        }

        if (flag) {
            num++;
            row++;
            printf("%4d ", n);
            if (row % 10 == 0) {
                printf("\n");
            }
        }
    }

    printf("\n\nFound %d special divisors N that reverse(D) divides reverse(N) for all divisors D of N, where N < 200\n", num);

    return 0;
}
