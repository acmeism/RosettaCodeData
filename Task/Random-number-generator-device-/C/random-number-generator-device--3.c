#include <inttypes.h> /* PRIu32 */
#include <stdlib.h> /* arc4random */
#include <stdio.h>  /* printf */

int
main()
{
  printf("%" PRIu32 "\n", arc4random());
  return 0;
}
