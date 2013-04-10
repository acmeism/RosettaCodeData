(load "@lib/native.l")

(gcc "str" NIL
   (duptest (Str) duptest 'S Str) )

#include <stdlib.h>
#include <string.h>

char *duptest(char *str) {
   static char *s;

   free(s);    // We simply dispose the result of the last call
   return s = strdup(str);
}
/**/

(println 'Duplicate (duptest "Hello world!"))
