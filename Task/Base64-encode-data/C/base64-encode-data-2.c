#include <stdio.h>
#include <unistd.h>

typedef unsigned long UL;

int main(void)
{
  const char *alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz"
        "0123456789+/";
  unsigned char c[4];
  UL u, len, w = 0;

  do {
    c[1] = c[2] = 0;

    if (!(len = read(fileno(stdin), c, 3))) break;
    u = (UL)c[0]<<16 | (UL)c[1]<<8 | (UL)c[2];

    putchar(alpha[u>>18]);
    putchar(alpha[u>>12 & 63]);
    putchar(len < 2 ? '=' : alpha[u>>6 & 63]);
    putchar(len < 3 ? '=' : alpha[u & 63]);

    if (++w == 19) w = 0, putchar('\n');
  } while (len == 3);

  if (w) putchar('\n');

  return 0;
}
