#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int Query(char*,unsigned*);

int main(int argc,char*argv[]) {
  char Buffer[1024], *pc;
  unsigned Size = (unsigned)sizeof(Buffer);
  if (!Query(Buffer,&Size))
    fputs("Failed to call Query",stdout);
  else
    for (pc = Buffer; Size--; ++pc)
      putchar(*pc);
  putchar('\n');
  return EXIT_SUCCESS;
}
