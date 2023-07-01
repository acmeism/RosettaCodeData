#include <stdio.h>

int main()
{
  int num;

  sscanf("0123459", "%d", &num);
  printf("%d\n", num); /* prints 123459 */

  sscanf("abcf123", "%x", &num);
  printf("%d\n", num); /* prints 180154659 */

  sscanf("7651", "%o", &num);
  printf("%d\n", num); /* prints 4009 */

  /* binary not supported */

  return 0;
}
