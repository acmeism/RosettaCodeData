#include <stdio.h>
#include <string.h>
/* testing */
int main()
{
   const char *t = "ingirumimusnocteetconsumimurigni";
   const char *template = "sequence \"%s\" is%s palindrome\n";
   int l = strlen(t);

   printf(template,
          t, palindrome(t) ? "" : "n't");
   printf(template,
          t, palindrome_r(t, 0, l) ? "" : "n't");
   return 0;
}
