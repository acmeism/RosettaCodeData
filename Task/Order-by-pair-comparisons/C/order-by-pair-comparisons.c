#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int interactiveCompare(const void *x1, const void *x2)
{
  const char *s1 = *(const char * const *)x1;
  const char *s2 = *(const char * const *)x2;
  static int count = 0;
  printf("(%d) Is %s <, ==, or > %s? Answer -1, 0, or 1: ", ++count, s1, s2);
  int response;
  scanf("%d", &response);
  return response;
}

void printOrder(const char *items[], int len)
{
  printf("{ ");
  for (int i = 0; i < len; ++i) printf("%s ", items[i]);
  printf("}\n");
}

int main(void)
{
  const char *items[] =
    {
      "violet", "red", "green", "indigo", "blue", "yellow", "orange"
    };

  qsort(items, sizeof(items)/sizeof(*items), sizeof(*items), interactiveCompare);
  printOrder(items, sizeof(items)/sizeof(*items));
  return 0;
}
