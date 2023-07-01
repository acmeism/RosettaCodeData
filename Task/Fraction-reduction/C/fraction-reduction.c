#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct IntArray_t {
    int *ptr;
    size_t length;
} IntArray;

IntArray make(size_t size) {
    IntArray temp;
    temp.ptr = calloc(size, sizeof(int));
    temp.length = size;
    return temp;
}

void destroy(IntArray *ia) {
    if (ia->ptr != NULL) {
        free(ia->ptr);

        ia->ptr = NULL;
        ia->length = 0;
    }
}

void zeroFill(IntArray dst) {
    memset(dst.ptr, 0, dst.length * sizeof(int));
}

int indexOf(const int n, const IntArray ia) {
    size_t i;
    for (i = 0; i < ia.length; i++) {
        if (ia.ptr[i] == n) {
            return i;
        }
    }
    return -1;
}

bool getDigits(int n, int le, IntArray digits) {
    while (n > 0) {
        int r = n % 10;
        if (r == 0 || indexOf(r, digits) >= 0) {
            return false;
        }
        le--;
        digits.ptr[le] = r;
        n /= 10;
    }
    return true;
}

int removeDigit(IntArray digits, size_t le, size_t idx) {
    static const int POWS[] = { 1, 10, 100, 1000, 10000 };
    int sum = 0;
    int pow = POWS[le - 2];
    size_t i;
    for (i = 0; i < le; i++) {
        if (i == idx) continue;
        sum += digits.ptr[i] * pow;
        pow /= 10;
    }
    return sum;
}

int main() {
    int lims[4][2] = { { 12, 97 }, { 123, 986 }, { 1234, 9875 }, { 12345, 98764 } };
    int count[5] = { 0 };
    int omitted[5][10] = { {0} };
    size_t upperBound = sizeof(lims) / sizeof(lims[0]);
    size_t i;

    for (i = 0; i < upperBound; i++) {
        IntArray nDigits = make(i + 2);
        IntArray dDigits = make(i + 2);
        int n;

        for (n = lims[i][0]; n <= lims[i][1]; n++) {
            int d;
            bool nOk;

            zeroFill(nDigits);
            nOk = getDigits(n, i + 2, nDigits);
            if (!nOk) {
                continue;
            }
            for (d = n + 1; d <= lims[i][1] + 1; d++) {
                size_t nix;
                bool dOk;

                zeroFill(dDigits);
                dOk = getDigits(d, i + 2, dDigits);
                if (!dOk) {
                    continue;
                }
                for (nix = 0; nix < nDigits.length; nix++) {
                    int digit = nDigits.ptr[nix];
                    int dix = indexOf(digit, dDigits);
                    if (dix >= 0) {
                        int rn = removeDigit(nDigits, i + 2, nix);
                        int rd = removeDigit(dDigits, i + 2, dix);
                        if ((double)n / d == (double)rn / rd) {
                            count[i]++;
                            omitted[i][digit]++;
                            if (count[i] <= 12) {
                                printf("%d/%d = %d/%d by omitting %d's\n", n, d, rn, rd, digit);
                            }
                        }
                    }
                }
            }
        }

        printf("\n");

        destroy(&nDigits);
        destroy(&dDigits);
    }

    for (i = 2; i <= 5; i++) {
        int j;

        printf("There are %d %d-digit fractions of which:\n", count[i - 2], i);

        for (j = 1; j <= 9; j++) {
            if (omitted[i - 2][j] == 0) {
                continue;
            }
            printf("%6d have %d's omitted\n", omitted[i - 2][j], j);
        }

        printf("\n");
    }

    return 0;
}
