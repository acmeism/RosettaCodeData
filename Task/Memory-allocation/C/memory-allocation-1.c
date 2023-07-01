#include <stdlib.h>

/* size of "members", in bytes */
#define SIZEOF_MEMB (sizeof(int))
#define NMEMB 100

int main()
{
  int *ints = malloc(SIZEOF_MEMB*NMEMB);
  /* realloc can be used to increase or decrease an already
     allocated memory (same as malloc if ints is NULL) */
  ints = realloc(ints, sizeof(int)*(NMEMB+1));
  /* calloc set the memory to 0s */
  int *int2 = calloc(NMEMB, SIZEOF_MEMB);
  /* all use the same free */
  free(ints); free(int2);
  return 0;
}
