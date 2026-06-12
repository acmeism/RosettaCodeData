#include <stdio.h>
#include <string.h>
#include <gmp.h>

char *power_of_six(unsigned int n, char *buf) {
    mpz_t p;
    mpz_init(p);
    mpz_ui_pow_ui(p, 6, n);
    mpz_get_str(buf, 10, p);
    mpz_clear(p);
    return buf;
}

char *smallest_six(unsigned int n) {
    static char nbuf[32], powbuf[1024];
    unsigned int p = 0;

    do {
        sprintf(nbuf, "%u", n);
        power_of_six(p++, powbuf);
    } while (!strstr(powbuf, nbuf));

    return powbuf;
}

int main() {
    unsigned int i;

    for (i=0; i<22; i++) {
        printf("%d: %s\n", i, smallest_six(i));
    }

    return 0;
}
