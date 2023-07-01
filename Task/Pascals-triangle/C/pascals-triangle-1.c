#include <stdio.h>

void pascaltriangle(unsigned int n)
{
  unsigned int c, i, j, k;

  for(i=0; i < n; i++) {
    c = 1;
    for(j=1; j <= 2*(n-1-i); j++) printf(" ");
    for(k=0; k <= i; k++) {
      printf("%3d ", c);
      c = c * (i-k)/(k+1);
    }
    printf("\n");
  }
}

int main()
{
  pascaltriangle(8);
  return 0;
}
