#if 0
This is file query.c

-*- mode: compilation; default-directory: "/tmp/" -*-
Compilation started at Mon Mar 12 20:36:25

make -k CFLAGS=-Wall query.o
cc -Wall   -c -o query.o query.c

Compilation finished at Mon Mar 12 20:36:26
#endif

#include<string.h>

int Query(char *Data, unsigned *Length) {
  const char *message = "Here am I";
  unsigned n = strlen(message);
  if (n <= *Length)
    return strncpy(Data, message, (size_t)n), *Length = n, 1;
  return 0;
}
