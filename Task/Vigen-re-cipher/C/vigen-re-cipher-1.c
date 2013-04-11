#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void upper_case(char *src)
{
        while (*src != '\0') {
                if (islower(*src)) *src &= ~0x20;
                src++;
        }
}

char* encipher(const char *src, char *key, int is_encode)
{
        int i, klen, slen;
        char *dest;

        dest = strdup(src);
        upper_case(dest);
        upper_case(key);

        /* strip out non-letters */
        for (i = 0, slen = 0; dest[slen] != '\0'; slen++)
                if (isupper(dest[slen]))
                        dest[i++] = dest[slen];

        dest[slen = i] = '\0'; /* null pad it, make it safe to use */

        klen = strlen(key);
        for (i = 0; i < slen; i++) {
                if (!isupper(dest[i])) continue;
                dest[i] = 'A' + (is_encode
                                ? dest[i] - 'A' + key[i % klen] - 'A'
                                : dest[i] - key[i % klen] + 26) % 26;
        }

        return dest;
}

int main()
{
        const char *str = "Beware the Jabberwock, my son! The jaws that bite, "
                    "the claws that catch!";
        const char *cod, *dec;
        char key[] = "VIGENERECIPHER";

        printf("Text: %s\n", str);
        printf("key:  %s\n", key);

        cod = encipher(str, key, 1); printf("Code: %s\n", cod);
        dec = encipher(cod, key, 0); printf("Back: %s\n", dec);

        /* free(dec); free(cod); */ /* nah */
        return 0;
}
