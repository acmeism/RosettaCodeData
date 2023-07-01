#include <stdio.h>
#include <string.h>
#include <locale.h>

typedef int bool;
typedef unsigned long long ull;

#define TRUE 1
#define FALSE 0

char as_digit(int d) {
    return (d >= 0 && d <= 9) ? d + '0' : d - 10 + 'a';
}

void revstr(char *str) {
    int i, len = strlen(str);
    char t;
    for (i = 0; i < len/2; ++i) {
        t = str[i];
        str[i] = str[len - i - 1];
        str[len - i - 1] = t;
    }
}

char* to_base(char s[], ull n, int b) {
    int i = 0;
    while (n) {
        s[i++] = as_digit(n % b);
        n /= b;
    }
    s[i] = '\0';
    revstr(s);
    return s;
}

ull uabs(ull a, ull  b) {
    return a > b ? a - b : b - a;
}

bool is_esthetic(ull n, int b) {
    int i, j;
    if (!n) return FALSE;
    i = n % b;
    n /= b;
    while (n) {
        j = n % b;
        if (uabs(i, j) != 1) return FALSE;
        n /= b;
        i = j;
    }
    return TRUE;
}

ull esths[45000];
int le = 0;

void dfs(ull n, ull m, ull i) {
    ull d, i1, i2;
    if (i >= n && i <= m) esths[le++] = i;
    if (i == 0 || i > m) return;
    d = i % 10;
    i1 = i * 10 + d - 1;
    i2 = i1 + 2;
    if (d == 0) {
        dfs(n, m, i2);
    } else if (d == 9) {
        dfs(n, m, i1);
    } else {
        dfs(n, m, i1);
        dfs(n, m, i2);
    }
}

void list_esths(ull n, ull n2, ull m, ull m2, int per_line, bool all) {
    int i;
    le = 0;
    for (i = 0; i < 10; ++i) {
        dfs(n2, m2, i);
    }
    printf("Base 10: %'d esthetic numbers between %'llu and %'llu:\n", le, n, m);
    if (all) {
        for (i = 0; i < le; ++i) {
            printf("%llu ", esths[i]);
            if (!(i+1)%per_line) printf("\n");
        }
    } else {
        for (i = 0; i < per_line; ++i) printf("%llu ", esths[i]);
        printf("\n............\n");
        for (i = le - per_line; i < le; ++i) printf("%llu ", esths[i]);
    }
    printf("\n\n");
}

int main() {
    ull n;
    int b, c;
    char ch[15] = {0};
    for (b = 2; b <= 16; ++b) {
        printf("Base %d: %dth to %dth esthetic numbers:\n", b, 4*b, 6*b);
        for (n = 1, c = 0; c < 6 * b; ++n) {
            if (is_esthetic(n, b)) {
                if (++c >= 4 * b) printf("%s ", to_base(ch, n, b));
            }
        }
        printf("\n\n");
    }
    char *oldLocale = setlocale(LC_NUMERIC, NULL);
    setlocale(LC_NUMERIC, "");

    // the following all use the obvious range limitations for the numbers in question
    list_esths(1000, 1010, 9999, 9898, 16, TRUE);
    list_esths(1e8, 101010101, 13*1e7, 123456789, 9, TRUE);
    list_esths(1e11, 101010101010, 13*1e10, 123456789898, 7, FALSE);
    list_esths(1e14, 101010101010101, 13*1e13, 123456789898989, 5, FALSE);
    list_esths(1e17, 101010101010101010, 13*1e16, 123456789898989898, 4, FALSE);
    setlocale(LC_NUMERIC, oldLocale);
    return 0;
}
