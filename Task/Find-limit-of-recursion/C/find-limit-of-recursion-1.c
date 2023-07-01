#include <stdio.h>

void recurse(unsigned int i)
{
  printf("%d\n", i);
  recurse(i+1); // 523756
}

int main()
{
  recurse(0);
  return 0;
}
