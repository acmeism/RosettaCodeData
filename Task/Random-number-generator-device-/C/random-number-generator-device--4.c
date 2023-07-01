#include <stdio.h>  /* printf */
#include <windows.h>
#include <wincrypt.h> /* CryptAcquireContext, CryptGenRandom */

int
main()
{
  HCRYPTPROV p;
  ULONG i;

  if (CryptAcquireContext(&p, NULL, NULL,
      PROV_RSA_FULL, CRYPT_VERIFYCONTEXT) == FALSE) {
    fputs("CryptAcquireContext failed.\n", stderr);
    return 1;
  }
  if (CryptGenRandom(p, sizeof i, (BYTE *)&i) == FALSE) {
    fputs("CryptGenRandom failed.\n", stderr);
    return 1;
  }
  printf("%lu\n", i);
  CryptReleaseContext(p, 0);
  return 0;
}
