#include <stdlib.h>
#include <stdio.h>

int main(void)
{
  unsigned int bottles = 99;
  do
  {
    printf("%u bottles of beer on the wall\n", bottles);
    printf("%u bottles of beer\n", bottles);
    printf("Take one down, pass it around\n");
    printf("%u bottles of beer on the wall\n\n", --bottles);
  } while(bottles > 0);
  return EXIT_SUCCESS;
}
