#include <locale.h>
#include <stdio.h>

int main()
{
  unsigned long long int trillion = 1000000000000;

  setlocale(LC_NUMERIC,"");

  printf("Locale : %s, One Trillion : %'llu\n", setlocale(LC_CTYPE,NULL),trillion);

  return 0;
}
