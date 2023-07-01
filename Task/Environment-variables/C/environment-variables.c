#include <stdlib.h>
#include <stdio.h>

int main() {
  puts(getenv("HOME"));
  puts(getenv("PATH"));
  puts(getenv("USER"));
  return 0;
}
