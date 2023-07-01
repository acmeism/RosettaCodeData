#include <stdio.h>

int i;

#define sum(i, lo_byname, hi_byname, term)      \
  ({                                            \
  int lo = lo_byname;                           \
  int hi = hi_byname;                           \
                                                \
  double temp = 0;                              \
  for (i = lo; i <= hi; ++i)                    \
    temp += term;                               \
  temp;                                         \
  })

int main () {
    printf("%f\n", sum(i, 1, 100, 1.0 / i));
    return 0;
}
