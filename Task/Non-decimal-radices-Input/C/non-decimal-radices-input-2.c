#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int main()
{
  int num;
  char *endptr;

  num = strtol("123459", &endptr, 0);
  assert(*endptr == '\0');
  printf("%d\n", num); /* prints 123459 */

  num = strtol("0xabcf123", &endptr, 0);
  assert(*endptr == '\0');
  printf("%d\n", num); /* prints 180154659 */

  num = strtol("07651", &endptr, 0);
  assert(*endptr == '\0');
  printf("%d\n", num); /* prints 4009 */

  /* binary not supported */

  return 0;
}
