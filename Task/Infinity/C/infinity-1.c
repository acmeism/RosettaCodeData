#include <math.h>	/* HUGE_VAL */
#include <stdio.h>	/* printf() */

double inf(void) {
  return HUGE_VAL;
}

int main() {
  printf("%g\n", inf());
  return 0;
}
