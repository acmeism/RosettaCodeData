#include <stdio.h>
#include <stdlib.h>

typedef struct frame
{
  int (*fn)(struct frame*);
  union { int constant; int* k; } u;
  struct frame *x1, *x2, *x3, *x4, *x5;
} FRAME;

FRAME* Frame(FRAME* f, int* k, FRAME* x1, FRAME* x2, FRAME *x3, FRAME *x4, FRAME *x5)
{
  f->u.k = k;
  f->x1 = x1;
  f->x2 = x2;
  f->x3 = x3;
  f->x4 = x4;
  f->x5 = x5;
  return f;
}

int F(FRAME* a) { return a->u.constant; }

int eval(FRAME* a) { return a->fn(a); }

int A(FRAME*);

int B(FRAME* a)
{
  int k = (*a->u.k -= 1);
  FRAME b = { B };
  return A(Frame(&b, &k, a, a->x1, a->x2, a->x3, a->x4));
}

int A(FRAME* a)
{
  return *a->u.k <= 0 ? eval(a->x4) + eval(a->x5) : B(a);
}

int main(int argc, char** argv)
{
  int k = argc == 2 ? strtol(argv[1], 0, 0) : 10;
  FRAME a = { B }, f1 = { F, { 1 } }, f0 = { F, { 0 } }, fn1 = { F, { -1 } };

  printf("%d\n", A(Frame(&a, &k, &f1, &fn1, &fn1, &f1, &f0)));
  return 0;
}
