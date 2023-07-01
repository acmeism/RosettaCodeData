#include <stdlib.h>
/* More "natural" way of ending the program: finish all work and return
   from main() */
int main(int argc, char **argv)
{
  /* work work work */
     ...
  return 0;  /* the return value is the exit code. see below */
}

if(problem){
  exit(exit_code);
  /* On unix, exit code 0 indicates success, but other OSes may follow
     different conventions.  It may be more portable to use symbols
     EXIT_SUCCESS and EXIT_FAILURE; it all depends on what meaning
     of codes are agreed upon.
  */
}
