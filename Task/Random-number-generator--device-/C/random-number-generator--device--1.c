#include <inttypes.h>
#include <stdio.h>
#include <stdint.h>

int main(int argc, char **argv)
{
    uint32_t v;
    FILE *r = fopen("/dev/urandom", "r");
    if (r == NULL)
    {
  perror("/dev/urandom");
  return 1;
    }

    size_t br = fread(&v, sizeof v, 1, r);
    if (br < 1)
    {
  fputs("/dev/urandom: Not enough bytes\n", stderr);
  return 1;
    }

    printf("%" PRIu32 "\n", v);
    fclose(r);
    return 0;
}
