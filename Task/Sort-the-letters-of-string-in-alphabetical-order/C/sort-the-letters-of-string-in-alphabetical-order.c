#include <stdio.h>

/* Sort a character string in place */
void strsort(char *s) {
    unsigned int n[256] = {0};
    unsigned char i = 0;
    char *t = s;
    while (*s) ++n[(unsigned char) *s++];
    while (++i) while (n[i]--) *t++ = (char) i;
}

int main() {
    char s[] = "Now is the time for all good men "
               "to come to the aid of their country.";
    puts(s);
    strsort(s);
    puts(s);
    return 0;
}
