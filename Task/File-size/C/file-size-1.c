#include <stdlib.h>
#include <stdio.h>

long getFileSize(const char *filename)
{
  long result;
  FILE *fh = fopen(filename, "rb");
  fseek(fh, 0, SEEK_END);
  result = ftell(fh);
  fclose(fh);
  return result;
}

int main(void)
{
  printf("%ld\n", getFileSize("input.txt"));
  printf("%ld\n", getFileSize("/input.txt"));
  return 0;
}
