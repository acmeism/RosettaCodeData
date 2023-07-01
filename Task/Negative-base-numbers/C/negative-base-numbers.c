#include <stdio.h>

const char DIGITS[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
const int DIGITS_LEN = 64;

void encodeNegativeBase(long n, long base, char *out) {
    char *ptr = out;

    if (base > -1 || base < -62) {
        /* Bounds check*/
        out = "";
        return;
    }
    if (n == 0) {
        /* Trivial case */
        out = "0";
        return;
    }

    /* Convert the number into a string (in reverse) */
    while (n != 0) {
        long rem = n % base;
        n = n / base;
        if (rem < 0) {
            n++;
            rem = rem - base;
        }
        *ptr = DIGITS[rem];
        ptr++;
    }
    *ptr = 0;

    /* Reverse the current string to get the final result */
    ptr--;
    while (out < ptr) {
        char t = *out;
        *out = *ptr;
        *ptr = t;
        out++;
        ptr--;
    }
    return;
}

long decodeNegativeBase(const char* ns, long base) {
    long value, bb;
    int i;
    const char *ptr;

    if (base < -62 || base > -1) {
        /* Bounds check */
        return 0;
    }
    if (ns[0] == 0 || (ns[0] == '0' && ns[1] == 0)) {
        /* Trivial case */
        return 0;
    }

    /* Find the end of the string */
    ptr = ns;
    while (*ptr != 0) {
        ptr++;
    }

    /* Convert */
    value = 0;
    bb = 1;
    ptr--;
    while (ptr >= ns) {
        for (i = 0; i < DIGITS_LEN; i++) {
            if (*ptr == DIGITS[i]) {
                value = value + i * bb;
                bb = bb * base;
                break;
            }
        }
        ptr--;
    }

    return value;
}

void driver(long n, long b) {
    char buf[64];
    long value;

    encodeNegativeBase(n, b, buf);
    printf("%12d encoded in base %3d = %12s\n", n, b, buf);

    value = decodeNegativeBase(buf, b);
    printf("%12s decoded in base %3d = %12d\n", buf, b, value);

    printf("\n");
}

int main() {
    driver(10, -2);
    driver(146, -3);
    driver(15, -10);
    driver(12, -62);

    return 0;
}
