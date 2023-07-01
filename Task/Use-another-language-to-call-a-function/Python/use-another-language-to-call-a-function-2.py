#if 0
//I rewrote the driver according to good sense, my style,
//and discussion --Kernigh 15:45, 12 February 2011 (UTC).
#endif

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

extern int Query(char*,unsigned*);

int main(int argc,char*argv[]) {
  char Buffer[1024], *pc;
  unsigned Size = sizeof(Buffer);
  if (!Query(Buffer,&Size))
    fputs("Failed to call Query",stdout);
  else
    for (pc = Buffer; Size--; ++pc)
      putchar(*pc);
  putchar('\n');
  return EXIT_SUCCESS;
}
