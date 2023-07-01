#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define caesar(x) rot(13, x)
#define decaesar(x) rot(13, x)
#define decrypt_rot(x, y) rot((26-x), y)

void rot(int c, char *str)
{
	int l = strlen(str);

        const char*  alpha_low  = "abcdefghijklmnopqrstuvwxyz";

        const char*  alpha_high = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";


       char subst;  /* substitution character */
       int idx;    /* index */

         int i; /* loop var */

	for (i = 0; i < l; i++)  /* for each letter in string */
	{
		if( 0 == isalpha(str[i]) )  continue; /* not alphabet character */

                idx = (int) (tolower(str[i]) - 'a') + c) % 26; /* compute index */

		if( isupper(str[i]) )
                    subst = alpha_high[idx];
                else
                    subst = alpha_low[idx];

               str[i] = subst;

	}
}


int main(int argc, char** argv)
{
	char str[] = "This is a top secret text message!";
	
	printf("Original: %s\n", str);
	caesar(str);
	printf("Encrypted: %s\n", str);
	decaesar(str);
	printf("Decrypted: %s\n", str);
	
	return 0;
}
