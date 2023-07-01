#include <stdio.h>
...

const char *list[] = {"Red","Green","Blue","Black","White"};
#define LIST_SIZE (sizeof(list)/sizeof(list[0]))

int ix;
for(ix=0; ix<LIST_SIZE; ix++) {
   printf("%s\n", list[ix]);
}
