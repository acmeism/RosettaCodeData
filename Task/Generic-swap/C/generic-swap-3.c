#include <stdio.h>

#define Swap(X,Y)  do{ __typeof__ (X) _T = X; X = Y; Y = _T; }while(0)

struct test
{
  int a, b, c;
};


int main()
{
  struct test t = { 1, 2, 3 };
  struct test h = { 4, 5, 6 };
  double alfa = 0.45, omega = 9.98;

  struct test *pt = &t;
  struct test *th = &h;

  printf("%d %d %d\n", t.a, t.b, t.c );
  Swap(t, h);
  printf("%d %d %d\n", t.a, t.b, t.c );
  printf("%d %d %d\n", h.a, h.b, h.c );

  printf("%lf\n", alfa);
  Swap(alfa, omega);
  printf("%lf\n", alfa);

  printf("%d\n", pt->a);
  Swap(pt, th);
  printf("%d\n", pt->a);
}
