#include <stdio.h>

int main() {
  remove("input.txt");
  remove("/input.txt");
  remove("docs");
  remove("/docs");
  return 0;
}
