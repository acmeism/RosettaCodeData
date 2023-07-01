#include <stdio.h>
#include <wchar.h>

int main(void)
{
   wchar_t *s = L"\x304A\x306F\x3088\x3046"; /* Japanese hiragana ohayou */
   size_t length;

   length = wcslen(s);
   printf("Length in characters = %d\n", length);
   printf("Length in bytes      = %d\n", sizeof(s) * sizeof(wchar_t));

   return 0;
}
