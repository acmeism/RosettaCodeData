#include <stdio.h>

#define DEBUG_INT(x) printf( #x " at line %d\nresult: %d\n\n", __LINE__, x)

int add(int x, int y) {
  int result = x + y;
  DEBUG_INT(x);
  DEBUG_INT(y);
  DEBUG_INT(result);
  DEBUG_INT(result+1);
  return result;
}

int main() {
  add(2, 7);
  return 0;
}
