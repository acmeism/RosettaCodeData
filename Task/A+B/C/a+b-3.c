#include <stdio.h>
#include <stdlib.h>
int main(int argc, char **argv) //not sure if argv counts as input stream... certainly it is brought here via input stream.
{
   printf("%d\n", atoi(*(argv+1)) + atoi(*(argv+2)));
   return 0;
}
