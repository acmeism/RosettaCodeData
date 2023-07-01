#include <stdio.h>

int main(int argc, char **argv) {
  FILE *in, *out;
  int c;

  in = fopen("input.txt", "r");
  if (!in) {
    fprintf(stderr, "Error opening input.txt for reading.\n");
    return 1;
  }

  out = fopen("output.txt", "w");
  if (!out) {
    fprintf(stderr, "Error opening output.txt for writing.\n");
    fclose(in);
    return 1;
  }

  while ((c = fgetc(in)) != EOF) {
    fputc(c, out);
  }

  fclose(out);
  fclose(in);
  return 0;
}
