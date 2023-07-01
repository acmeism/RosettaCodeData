#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

static const int d[][10] = {
    {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, {1, 2, 3, 4, 0, 6, 7, 8, 9, 5},
    {2, 3, 4, 0, 1, 7, 8, 9, 5, 6}, {3, 4, 0, 1, 2, 8, 9, 5, 6, 7},
    {4, 0, 1, 2, 3, 9, 5, 6, 7, 8}, {5, 9, 8, 7, 6, 0, 4, 3, 2, 1},
    {6, 5, 9, 8, 7, 1, 0, 4, 3, 2}, {7, 6, 5, 9, 8, 2, 1, 0, 4, 3},
    {8, 7, 6, 5, 9, 3, 2, 1, 0, 4}, {9, 8, 7, 6, 5, 4, 3, 2, 1, 0},
};

static const int inv[] = {0, 4, 3, 2, 1, 5, 6, 7, 8, 9};

static const int p[][10] = {
    {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, {1, 5, 7, 6, 2, 8, 3, 0, 9, 4},
    {5, 8, 0, 3, 7, 9, 6, 1, 4, 2}, {8, 9, 1, 6, 0, 4, 3, 5, 2, 7},
    {9, 4, 5, 3, 1, 2, 6, 8, 7, 0}, {4, 2, 8, 6, 5, 7, 3, 9, 0, 1},
    {2, 7, 9, 3, 8, 0, 6, 4, 1, 5}, {7, 0, 4, 6, 9, 1, 3, 2, 5, 8},
};

int verhoeff(const char* s, bool validate, bool verbose) {
    if (verbose) {
        const char* t = validate ? "Validation" : "Check digit";
        printf("%s calculations for '%s':\n\n", t, s);
        puts(u8" i  n\xE1\xB5\xA2  p[i,n\xE1\xB5\xA2]  c");
        puts("------------------");
    }
    int len = strlen(s);
    if (validate)
        --len;
    int c = 0;
    for (int i = len; i >= 0; --i) {
        int ni = (i == len && !validate) ? 0 : s[i] - '0';
        assert(ni >= 0 && ni < 10);
        int pi = p[(len - i) % 8][ni];
        c = d[c][pi];
        if (verbose)
            printf("%2d  %d      %d     %d\n", len - i, ni, pi, c);
    }
    if (verbose && !validate)
        printf("\ninv[%d] = %d\n", c, inv[c]);
    return validate ? c == 0 : inv[c];
}

int main() {
    const char* ss[3] = {"236", "12345", "123456789012"};
    for (int i = 0; i < 3; ++i) {
        const char* s = ss[i];
        bool verbose = i < 2;
        int c = verhoeff(s, false, verbose);
        printf("\nThe check digit for '%s' is '%d'.\n", s, c);
        int len = strlen(s);
        char sc[len + 2];
        strncpy(sc, s, len + 2);
        for (int j = 0; j < 2; ++j) {
            sc[len] = (j == 0) ? c + '0' : '9';
            int v = verhoeff(sc, true, verbose);
            printf("\nThe validation for '%s' is %s.\n", sc,
                   v ? "correct" : "incorrect");
        }
    }
    return 0;
}
