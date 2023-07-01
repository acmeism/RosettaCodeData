#include<stdio.h>
#include<string.h>

#define TRUE 1
#define FALSE 0

typedef char bool;

typedef unsigned long long uint64;

bool div_by_all(uint64 num, char digits[], int len) {
    int i, d;
    for (i = 0; i < len; ++i) {
        d = digits[i];
        d = (d <= '9') ? d - '0' : d - 'W';
        if (num % d != 0) return FALSE;
    }
    return TRUE;
}

int main() {
    uint64 i, magic = 15 * 14 * 13 * 12 * 11;
    uint64 high = 0xfedcba987654321 / magic * magic;
    int j, len;
    char c, *p, s[17], sd[16], found[16];

    for (i = high; i >= magic; i -= magic) {
        if (i % 16 == 0) continue;   // can't end in '0'
        snprintf(s, 17, "%llx", i);  // always generates lower case a-f
        if (strchr(s, '0') - s >= 0) continue; // can't contain '0'
        for (j = 0; j < 16; ++j) found[j] = FALSE;
        len = 0;
        for (p = s; *p; ++p) {
            if (*p <= '9') {
                c = *p - '0';
            } else {
                c = *p - 87;
            }
            if (!found[c]) {
                found[c] = TRUE;
                sd[len++] = *p;
            }
        }
        if (len != p - s) {
            continue;  // digits must be unique
        }
        if (div_by_all(i, sd, len)) {
            printf("Largest hex number is %llx\n", i);
            break;
        }
    }
    return 0;
}
