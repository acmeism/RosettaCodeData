#include <stdio.h>

int main()
{
  int door, square, increment;
  for (door = 1, square = 1, increment = 1; door <= 100; door++ == square && (square += increment += 2))
    printf("door #%d is %s.\n", door, (door == square? "open" : "closed"));
  return 0;
}
