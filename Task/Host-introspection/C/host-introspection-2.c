#include <stdio.h>
#include <arpa/inet.h>

int main()
{
  if (htonl(1) == 1)
    printf("big endian\n");
  else
    printf("little endian\n");
}
