#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/sha.h>

int main()
{
  int i;
  unsigned char result[SHA_DIGEST_LENGTH];
  const char *string = "Rosetta Code";

  SHA1(string, strlen(string), result);

  for(i = 0; i < SHA_DIGEST_LENGTH; i++)
    printf("%02x%c", result[i], i < (SHA_DIGEST_LENGTH-1) ? ' ' : '\n');

  return EXIT_SUCCESS;
}
