#include <string.h>
#include <stdio.h>

int startsWith(const char* container, const char* target)
{
  size_t clen = strlen(container), tlen = strlen(target);
  if (clen < tlen)
    return 0;
  return strncmp(container, target, tlen) == 0;
}

int endsWith(const char* container, const char* target)
{
  size_t clen = strlen(container), tlen = strlen(target);
  if (clen < tlen)
    return 0;
  return strncmp(container + clen - tlen, target, tlen) == 0;
}

int doesContain(const char* container, const char* target)
{
  return strstr(container, target) != 0;
}

int main(void)
{
  printf("Starts with Test ( Hello,Hell ) : %d\n", startsWith("Hello","Hell"));
  printf("Ends with Test ( Code,ode ) : %d\n", endsWith("Code","ode"));
  printf("Contains Test ( Google,msn ) : %d\n", doesContain("Google","msn"));

  return 0;
}
