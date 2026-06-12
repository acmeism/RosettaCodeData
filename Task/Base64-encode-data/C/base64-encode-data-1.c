#include <stdio.h>
#include <stdlib.h>
#include <resolv.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>

int main() {
  int fin = open("favicon.ico",  O_RDONLY);
  if (fin == -1)
    return 1;

  struct stat st;
  if (fstat(fin, &st))
    return 1;

  void *bi = mmap(0, st.st_size, PROT_READ, MAP_PRIVATE, fin,  0);
  if (bi == MAP_FAILED)
    return 1;

  int outLength = ((st.st_size + 2) / 3) * 4 + 1;
  char *outBuffer = malloc(outLength);
  if (outBuffer == NULL)
    return 1;

  int encodedLength = b64_ntop(bi, st.st_size, outBuffer, outLength);
  if (encodedLength < 0)
    return 1;

  puts(outBuffer);

  free(outBuffer);
  munmap(bi, st.st_size);
  close(fin);

  return 0;
}
