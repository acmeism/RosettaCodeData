#include <stdio.h>

int main(int argc, char const *argv[]) {
  for (char c = 0x41; c < 0x5b; c ++) putchar(c);
  putchar('\n');
  for (char c = 0x61; c < 0x7b; c ++) putchar(c);
  putchar('\n');
  return 0;
}
