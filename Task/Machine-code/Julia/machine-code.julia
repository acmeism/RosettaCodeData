using Cxx

cxx"""
#include <stdio.h>
#include <sys/mman.h>
#include <string.h>

int test (int a, int b)
{
  /*
       mov EAX, [ESP+4]
       add EAX, [ESP+8]
       ret
  */
  char code[] = {0x8B, 0x44, 0x24, 0x4, 0x3, 0x44, 0x24, 0x8, 0xC3};
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

int main ()
{
  printf("%d\n", test(7,12));
  return 0;
}
"""

julia_function = @cxx main()
julia_function()
