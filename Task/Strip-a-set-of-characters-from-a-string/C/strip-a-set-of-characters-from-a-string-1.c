#include <string.h>
#include <stdio.h>
#include <stdlib.h>

  /* removes all chars from string */
char *strip_chars(const char *string, const char *chars)
{
  char * newstr = malloc(strlen(string) + 1);
  int counter = 0;

  for ( ; *string; string++) {
    if (!strchr(chars, *string)) {
      newstr[ counter ] = *string;
      ++ counter;
    }
  }

  newstr[counter] = 0;
  return newstr;
}

int main(void)
{
  char *new = strip_chars("She was a soul stripper. She took my heart!", "aei");
  printf("%s\n", new);

  free(new);
  return 0;
}
