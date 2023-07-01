#include <stdio.h>

void move(int n, int from, int via, int to)
{
  if (n > 1) {
    move(n - 1, from, to, via);
    printf("Move disk from pole %d to pole %d\n", from, to);
    move(n - 1, via, from, to);
  } else {
    printf("Move disk from pole %d to pole %d\n", from, to);
  }
}
int main()
{
  move(4, 1,2,3);
  return 0;
}
