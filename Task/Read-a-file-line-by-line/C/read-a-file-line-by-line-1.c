#include <stdio.h>
#include <stdlib.h>
int main (void)
{
  char buf[256];
  while (fgets (buf, sizeof(buf), stdin)) {
    printf("line: %s", buf);
  }
  if (ferror(stdin)) {
    fprintf(stderr,"Oops, error reading stdin\n");
    abort();
  }
  return 0;
}
