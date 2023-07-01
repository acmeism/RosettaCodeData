#include <stdio.h>
#include "callback.h"

/*
 * We don't need this function outside of this file, so
 * we declare it static.
 */
static void callbackFunction(int location, int value)
{
  printf("array[%d] = %d\n", location, value);
}

void map(int* array, int len, void(*callback)(int,int))
{
  int i;
  for(i = 0; i < len; i++)
  {
     callback(i, array[i]);
  }
}

int main()
{
  int array[] = { 1, 2, 3, 4 };
  map(array, 4, callbackFunction);
  return 0;
}
