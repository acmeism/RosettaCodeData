#!/usr/bin/perl
use strict;
use warnings;

use Inline "C";
printf("%d\n", add(7, 12));

__END__
__C__
#include <stdio.h>
#include <sys/mman.h>
#include <string.h>

int add (int a, int b)
{
#ifdef __x86_64__
  char code[] = {0x55, 0x48, 0x89, 0xe5, 0x89, 0x7d,
                 0xfc, 0x89, 0x75, 0xf8, 0x8b, 0x75,
                 0xfc, 0x03, 0x75, 0xf8, 0x89, 0x75,
                 0xf4, 0x8b, 0x45, 0xf4, 0x5d, 0xc3};
#else
  char code[] = {0x8B, 0x44, 0x24, 0x4, 0x3, 0x44, 0x24, 0x8, 0xC3};
#endif

  void *buf;
  int c;
  /* copy code to executable buffer */
  buf = mmap (0,sizeof(code),PROT_READ|PROT_WRITE|PROT_EXEC,
             MAP_PRIVATE|MAP_ANON,-1,0);

  memcpy (buf, code, sizeof(code));
  /* run code */
  c = ((int (*) (int, int))buf)(a, b);
  /* free buffer */
  munmap (buf, sizeof(code));
  return c;
}
