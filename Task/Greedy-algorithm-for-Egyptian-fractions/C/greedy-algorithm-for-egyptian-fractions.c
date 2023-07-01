#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

typedef int64_t integer;

struct Pair {
    integer md;
    int tc;
};

integer mod(integer x, integer y) {
    return ((x % y) + y) % y;
}

integer gcd(integer a, integer b) {
    if (0 == a) return b;
    if (0 == b) return a;
    if (a == b) return a;
    if (a > b) return gcd(a - b, b);
    return gcd(a, b - a);
}

void write0(bool show, char *str) {
    if (show) {
        printf(str);
    }
}

void write1(bool show, char *format, integer a) {
    if (show) {
        printf(format, a);
    }
}

void write2(bool show, char *format, integer a, integer b) {
    if (show) {
        printf(format, a, b);
    }
}

struct Pair egyptian(integer x, integer y, bool show) {
    struct Pair ret;
    integer acc = 0;
    bool first = true;

    ret.tc = 0;
    ret.md = 0;

    write2(show, "Egyptian fraction for %lld/%lld: ", x, y);
    while (x > 0) {
        integer z = (y + x - 1) / x;
        if (z == 1) {
            acc++;
        } else {
            if (acc > 0) {
                write1(show, "%lld + ", acc);
                first = false;
                acc = 0;
                ret.tc++;
            } else if (first) {
                first = false;
            } else {
                write0(show, " + ");
            }
            if (z > ret.md) {
                ret.md = z;
            }
            write1(show, "1/%lld", z);
            ret.tc++;
        }
        x = mod(-y, x);
        y = y * z;
    }
    if (acc > 0) {
        write1(show, "%lld", acc);
        ret.tc++;
    }
    write0(show, "\n");

    return ret;
}

int main() {
    struct Pair p;
    integer nm = 0, dm = 0, dmn = 0, dmd = 0, den = 0;;
    int tm, i, j;

    egyptian(43, 48, true);
    egyptian(5, 121, true); // final term cannot be represented correctly
    egyptian(2014, 59, true);

    tm = 0;
    for (i = 1; i < 100; i++) {
        for (j = 1; j < 100; j++) {
            p = egyptian(i, j, false);
            if (p.tc > tm) {
                tm = p.tc;
                nm = i;
                dm = j;
            }
            if (p.md > den) {
                den = p.md;
                dmn = i;
                dmd = j;
            }
        }
    }
    printf("Term max is %lld/%lld with %d terms.\n", nm, dm, tm); // term max is correct
    printf("Denominator max is %lld/%lld\n", dmn, dmd);           // denominator max is not correct
    egyptian(dmn, dmd, true);                                     // enough digits cannot be represented without bigint

    return 0;
}
