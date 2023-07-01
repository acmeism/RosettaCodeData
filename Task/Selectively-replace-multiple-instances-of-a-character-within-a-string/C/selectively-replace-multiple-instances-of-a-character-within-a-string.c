#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
  const char string[] = "abracadabra";

  char *replaced = malloc(sizeof(string));
  strcpy(replaced, string);

  // Null terminated replacement character arrays
  const char *aRep = "ABaCD";
  const char *bRep = "E";
  const char *rRep = "rF";

  for (char *c = replaced; *c; ++c) {
    switch (*c) {
    case 'a':
      if (*aRep)
        *c = *aRep++;
      break;
    case 'b':
      if (*bRep)
        *c = *bRep++;
      break;
    case 'r':
      if (*rRep)
        *c = *rRep++;
      break;
    }
  }

  printf("%s\n", replaced);

  free(replaced);
  return 0;
}
