#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

enum {
  LOWER = 0,
  UPPER = 100,
  KEY = LOWER-1 // some value that is not in the valid range
};

char dummy;
// A pointer to represent the integer 0, and the basis of our integer-as-pointer
// representation. We can't use the null pointer because bsearch() returns that
// for not found.
#define ZERO ((void *)&dummy)

int get_value(int x) {
  if (x == KEY)
    return 0;
  printf("My guess is: %d. Is it too high, too low, or correct? (H/L/C) ", x);
  char input[2] = " ";
  scanf("%1s", input);
  switch (tolower(input[0])) {
    case 'l':
      return -1;
    case 'h':
      return 1;
    case 'c':
      return 0;
  }
  fprintf(stderr, "Invalid input\n");
  exit(1);
  return 0;
}

int my_cmp(const void *x, const void *y) {
  return get_value(x - ZERO) - get_value(y - ZERO);
}

int main() {
  printf("Instructions:\n"
	 "Think of integer number from %d (inclusive) to %d (exclusive) and\n"
	 "I will guess it. After each guess, you respond with L, H, or C depending\n"
	 "on if my guess was too low, too high, or correct.\n",
	 LOWER, UPPER);
  void *result = bsearch(ZERO + KEY, ZERO + LOWER, UPPER-LOWER, 1, my_cmp);
  if (result == NULL)
    fprintf(stderr, "That is impossible.\n");
  else
    printf("Your number is %d.\n", (int)(result - ZERO));
  return 0;
}
