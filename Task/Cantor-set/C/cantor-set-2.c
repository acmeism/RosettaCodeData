#include <stdio.h>

#define WIDTH 81

int l, w, n, i;

void split (char* s)
{
  l /= 3; n = 0;

  do {
    n += l; if (s[n] != ' ') for (i = 0; i < l; i++) s[n+i] = ' '; n += l+l;
  } while (n < w);
}

void go (char* s)
{
  puts (s); do { split (s); puts (s); } while (l > 1);
}

int main ()
{
  char s[WIDTH+1];

  l = w = WIDTH;
  for (i = 0; i < WIDTH; i++) s[i] = '#'; s[WIDTH] = '\0'; go (s);
  return (0);
}
