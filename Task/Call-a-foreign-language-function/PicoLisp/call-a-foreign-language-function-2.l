/*
How to create the shared lib/so file:
gcc -c -Wall -Werror -fPIC duptest.c
gcc -shared -o duptest.so duptest.o -Wno-undef
*/

#include <stdlib.h>
#include <string.h>

extern char * duptest(char * str);

char * duptest(char * str) {
   static char * s;

   free(s);    // We simply dispose the result of the last call
   return s = strdup(str);
}

int main() {
}
