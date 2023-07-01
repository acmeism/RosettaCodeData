//Aamrun, 11th July 2022

#include <stdio.h>

int F(int n,int x,int y) {
  if (n == 0) {
    return x + y;
  }

  else if (y == 0) {
    return x;
  }

  return F(n - 1, F(n, x, y - 1), F(n, x, y - 1) + y);
}

int main() {
  printf("F1(3,3) = %d",F(1,3,3));
  return 0;
}
