#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>

int main(void)
{
  struct stat foo;
  stat("input.txt", &foo);
  printf("%ld\n", foo.st_size);
  stat("/input.txt", &foo);
  printf("%ld\n", foo.st_size);
  return 0;
}
