#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gmp.h>

int main(void)
{
    mpz_t n, d, e, pt, ct;

    mpz_init(pt);
    mpz_init(ct);
    mpz_init_set_str(n, "9516311845790656153499716760847001433441357", 10);
    mpz_init_set_str(e, "65537", 10);
    mpz_init_set_str(d, "5617843187844953170308463622230283376298685", 10);

    const char *plaintext = "Rossetta Code";
    mpz_import(pt, strlen(plaintext), 1, 1, 0, 0, plaintext);

    if (mpz_cmp(pt, n) > 0)
        abort();

    mpz_powm(ct, pt, e, n);
    gmp_printf("Encoded:   %Zd\n", ct);

    mpz_powm(pt, ct, d, n);
    gmp_printf("Decoded:   %Zd\n", pt);

    char buffer[64];
    mpz_export(buffer, NULL, 1, 1, 0, 0, pt);
    printf("As String: %s\n", buffer);

    mpz_clears(pt, ct, n, e, d, NULL);
    return 0;
}
