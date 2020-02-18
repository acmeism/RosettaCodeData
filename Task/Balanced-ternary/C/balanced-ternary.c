#include <stdio.h>
#include <string.h>

void reverse(char *p) {
    size_t len = strlen(p);
    char *r = p + len - 1;
    while (p < r) {
        *p ^= *r;
        *r ^= *p;
        *p++ ^= *r--;
    }
}

void to_bt(int n, char *b) {
    static char d[] = { '0', '+', '-' };
    static int v[] = { 0, 1, -1 };

    char *ptr = b;
    *ptr = 0;

    while (n) {
        int r = n % 3;
        if (r < 0) {
            r += 3;
        }

        *ptr = d[r];
        *(++ptr) = 0;

        n -= v[r];
        n /= 3;
    }

    reverse(b);
}

int from_bt(const char *a) {
    int n = 0;

    while (*a != '\0') {
        n *= 3;
        if (*a == '+') {
            n++;
        } else if (*a == '-') {
            n--;
        }
        a++;
    }

    return n;
}

char last_char(char *ptr) {
    char c;

    if (ptr == NULL || *ptr == '\0') {
        return '\0';
    }

    while (*ptr != '\0') {
        ptr++;
    }
    ptr--;

    c = *ptr;
    *ptr = 0;
    return c;
}

void add(const char *b1, const char *b2, char *out) {
    if (*b1 != '\0' && *b2 != '\0') {
        char c1[16];
        char c2[16];
        char ob1[16];
        char ob2[16];
        char d[3] = { 0, 0, 0 };
        char L1, L2;

        strcpy(c1, b1);
        strcpy(c2, b2);
        L1 = last_char(c1);
        L2 = last_char(c2);
        if (L2 < L1) {
            L2 ^= L1;
            L1 ^= L2;
            L2 ^= L1;
        }

        if (L1 == '-') {
            if (L2 == '0') {
                d[0] = '-';
            }
            if (L2 == '-') {
                d[0] = '+';
                d[1] = '-';
            }
        }
        if (L1 == '+') {
            if (L2 == '0') {
                d[0] = '+';
            }
            if (L2 == '-') {
                d[0] = '0';
            }
            if (L2 == '+') {
                d[0] = '-';
                d[1] = '+';
            }
        }
        if (L1 == '0') {
            if (L2 == '0') {
                d[0] = '0';
            }
        }

        add(c1, &d[1], ob1);
        add(ob1, c2, ob2);
        strcpy(out, ob2);

        d[1] = 0;
        strcat(out, d);
    } else if (*b1 != '\0') {
        strcpy(out, b1);
    } else if (*b2 != '\0') {
        strcpy(out, b2);
    } else {
        *out = '\0';
    }
}

void unary_minus(const char *b, char *out) {
    while (*b != '\0') {
        if (*b == '-') {
            *out++ = '+';
            b++;
        } else if (*b == '+') {
            *out++ = '-';
            b++;
        } else {
            *out++ = *b++;
        }
    }
    *out = '\0';
}

void subtract(const char *b1, const char *b2, char *out) {
    char buf[16];
    unary_minus(b2, buf);
    add(b1, buf, out);
}

void mult(const char *b1, const char *b2, char *out) {
    char r[16] = "0";
    char t[16];
    char c1[16];
    char c2[16];
    char *ptr = c2;

    strcpy(c1, b1);
    strcpy(c2, b2);

    reverse(c2);

    while (*ptr != '\0') {
        if (*ptr == '+') {
            add(r, c1, t);
            strcpy(r, t);
        }
        if (*ptr == '-') {
            subtract(r, c1, t);
            strcpy(r, t);
        }
        strcat(c1, "0");

        ptr++;
    }

    ptr = r;
    while (*ptr == '0') {
        ptr++;
    }
    strcpy(out, ptr);
}

int main() {
    const char *a = "+-0++0+";
    char b[16];
    const char *c = "+-++-";
    char t[16];
    char d[16];

    to_bt(-436, b);
    subtract(b, c, t);
    mult(a, t, d);

    printf("      a: %14s %10d\n", a, from_bt(a));
    printf("      b: %14s %10d\n", b, from_bt(b));
    printf("      c: %14s %10d\n", c, from_bt(c));
    printf("a*(b-c): %14s %10d\n", d, from_bt(d));

    return 0;
}
