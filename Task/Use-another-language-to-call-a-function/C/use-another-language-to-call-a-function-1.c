#if 0
I rewrote the driver according to good sense, my style,
and discussion.

This is file main.c on Autumn 2011 ubuntu linux release.
The emacs compile command output:

-*- mode: compilation; default-directory: "/tmp/" -*-
Compilation started at Mon Mar 12 20:25:27

make -k CFLAGS=-Wall main.o
cc -Wall   -c -o main.o main.c

Compilation finished at Mon Mar 12 20:25:27
#endif

#include <stdio.h>
#include <stdlib.h>

extern int Query(char *Data, unsigned *Length);

int main(int argc, char *argv[]) {
  char Buffer[1024], *pc;
  unsigned Size = sizeof(Buffer);
  if (!Query(Buffer, &Size))
    fputs("failed to call Query", stdout);
  else
    for (pc = Buffer; Size--; ++pc)
      putchar(*pc);
  putchar('\n');
  return EXIT_SUCCESS;
}
