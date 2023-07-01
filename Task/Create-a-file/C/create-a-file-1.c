#include <stdio.h>

int main() {
  FILE *fh = fopen("output.txt", "w");
  fclose(fh);

  return 0;
}
