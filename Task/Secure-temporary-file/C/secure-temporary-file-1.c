#include <stdlib.h>
#include <stdio.h>

int main(void)
{
  FILE *fh = tmpfile(); /* file is automatically deleted when program exits */
  /* do stuff with stream "fh" */
  fclose(fh);
  /* The C standard library also has a tmpnam() function to create a file
    for you to open later. But you should not use it because someone else might
    be able to open the file from the time it is created by this function to the
    time you open it. */
  return 0;
}
