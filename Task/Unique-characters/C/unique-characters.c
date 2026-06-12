#include <stdio.h>
#include <string.h>

char *uniques(char *str[], char *buf) {
    static unsigned counts[256];
    unsigned i;
    char *s, *o = buf;
    memset(counts, 0, 256 * sizeof(unsigned));

    for (; *str; str++)
        for (s = *str; *s; s++)
            counts[(unsigned) *s]++;

    for (i=0; i<256; i++)
        if (counts[i] == 1)
            *o++ = (char) i;

    *o = '\0';
    return buf;
}

int main() {
    char buf[256];
    char *strings[] = {
        "133252abcdeeffd",
        "a6789798st",
        "yxcdfgxcyz",
        NULL
    };

    printf("%s\n", uniques(strings, buf));
    return 0;
}
