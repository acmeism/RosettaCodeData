#include <stdio.h>

void lcs(const char * const sa, const char * const sb, char ** const beg, char ** const end) {
    size_t apos, bpos;
    ptrdiff_t len;

    *beg = 0;
    *end = 0;
    len = 0;

    for (apos = 0; sa[apos] != 0; ++apos) {
        for (bpos = 0; sb[bpos] != 0; ++bpos) {
            if (sa[apos] == sb[bpos]) {
                len = 1;
                while (sa[apos + len] != 0 && sb[bpos + len] != 0 && sa[apos + len] == sb[bpos + len]) {
                    len++;
                }
            }

            if (len > *end - *beg) {
                *beg = sa + apos;
                *end = *beg + len;
                len = 0;
            }
        }
    }
}

int main() {
    char *s1 = "thisisatest";
    char *s2 = "testing123testing";
    char *beg, *end, *it;

    lcs(s1, s2, &beg, &end);

    for (it = beg; it != end; it++) {
        putchar(*it);
    }
    printf("\n");

    return 0;
}
