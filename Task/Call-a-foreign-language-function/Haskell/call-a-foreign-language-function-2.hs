#include <string.h>
#include "icall.h"  // a header routine from the Unicon sources - provides helpful type-conversion macros

int strdup_wrapper (int argc, descriptor *argv)
{
  ArgString (1); // check that the first argument is a string

  RetString (strdup (StringVal(argv[1]))); // call strdup, convert and return result
}

// and strcat, for a result that does not equal the input
int strcat_wrapper (int argc, descriptor *argv)
{
  ArgString (1);
  ArgString (2);
  char * result = strcat (StringVal(argv[1]), StringVal(argv[2]));
  RetString (result);
}
