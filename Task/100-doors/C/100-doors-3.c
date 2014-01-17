#include <stdio.h>

int main()
{
  int square = 1, increment = 3, door;
  for (door = 1; door <= 100; ++door)
  {
    printf("door #%d", door);
    if (door == square)
    {
      printf(" is open.\n");
      square += increment;
      increment += 2;
    }
    else
      printf(" is closed.\n");
  }
  return 0;
}
