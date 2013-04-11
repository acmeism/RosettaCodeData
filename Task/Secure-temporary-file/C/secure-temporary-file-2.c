#include <stdlib.h>
#include <stdio.h>

int main(void)
{
  char filename[] = "/tmp/prefixXXXXXX";
  int fd = mkstemp(filename);
  puts(filename);
  /* do stuff with file descriptor "fd" */
  close(fd);
  return 0;
}
