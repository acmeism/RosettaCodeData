#include <alloca.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define V(cc, exp) if (!strncmp(iban, cc, 2)) return len == exp

/* Validate country code against expected length. */
int valid_cc(const char *iban, int len)
{
    V("AL", 28); V("AD", 24); V("AT", 20); V("AZ", 28); V("BE", 16); V("BH", 22); V("BA", 20); V("BR", 29);
    V("BG", 22); V("CR", 21); V("HR", 21); V("CY", 28); V("CZ", 24); V("DK", 18); V("DO", 28); V("EE", 20);
    V("FO", 18); V("FI", 18); V("FR", 27); V("GE", 22); V("DE", 22); V("GI", 23); V("GR", 27); V("GL", 18);
    V("GT", 28); V("HU", 28); V("IS", 26); V("IE", 22); V("IL", 23); V("IT", 27); V("KZ", 20); V("KW", 30);
    V("LV", 21); V("LB", 28); V("LI", 21); V("LT", 20); V("LU", 20); V("MK", 19); V("MT", 31); V("MR", 27);
    V("MU", 30); V("MC", 27); V("MD", 24); V("ME", 22); V("NL", 18); V("NO", 15); V("PK", 24); V("PS", 29);
    V("PL", 28); V("PT", 25); V("RO", 24); V("SM", 27); V("SA", 24); V("RS", 22); V("SK", 24); V("SI", 19);
    V("ES", 24); V("SE", 24); V("CH", 21); V("TN", 24); V("TR", 26); V("AE", 23); V("GB", 22); V("VG", 24);

    return 0;
}

/* Remove blanks from s in-place, return its new length. */
int strip(char *s)
{
    int i = -1, m = 0;

    while(s[++i]) {
        s[i - m] = s[i];
        m += s[i] <= 32;
    }

    s[i - m] = 0;
    return i - m;
}

/* Calculate the mod 97 of an arbitrarily large number (as a string). */
int mod97(const char *s, int len)
{
    int i, j, parts = len / 7;
    char rem[10] = "00";

    for (i = 1; i <= parts + (len % 7 != 0); ++i) {
        strncpy(rem + 2, s + (i - 1) * 7, 7);
        j = atoi(rem) % 97;
        rem[0] = j / 10 + '0';
        rem[1] = j % 10 + '0';
    }

    return atoi(rem) % 97;
}

int valid_iban(char *iban)
{
    int i, j, l = 0, sz = strip(iban);
    char *rot, *trans;

    /* Ensure upper alphanumeric input and count letters. */
    for (i = 0; i < sz; ++i) {
        if (!isdigit(iban[i]) && !isupper(iban[i]))
            return 0;
        l += !!isupper(iban[i]);
    }

    if (!valid_cc(iban, sz))
        return 0;

    /* Move the first four characters to the end. */
    rot = alloca(sz);
    strcpy(rot, iban + 4);
    strncpy(rot + sz - 4, iban, 4);

    /* Allocate space for the transformed IBAN. */
    trans = alloca(sz + l);
    trans[sz + l] = 0;

    /* Convert A to 10, B to 11, etc. */
    for (i = j = 0; i < sz; ++i, ++j) {
        if (isdigit(rot[i]))
            trans[j] = rot[i];
        else {
            trans[j]   = (rot[i] - 55) / 10 + '0';
            trans[++j] = (rot[i] - 55) % 10 + '0';
        }
    }

    return mod97(trans, sz + l) == 1;
}

int main(int _, char **argv)
{
    while (--_, *++argv)
        printf("%s is %svalid.\n", *argv, valid_iban(*argv) ? "" : "in");

    return 0;
}
