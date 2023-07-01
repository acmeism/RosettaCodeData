#include <stdio.h>

int main()
{
  int intspace;
  int *address;

  address = &intspace; // address = 0x100;
  *address = 65535;
  printf("%p: %08x (=%08x)\n", address, *address, intspace);
  // likely we must be worried about endianness, e.g.
  *((char*)address) = 0x00;
  *((char*)address+1) = 0x00;
  *((char*)address+2) = 0xff;
  *((char*)address+3) = 0xff; // if sizeof(int) == 4!
  // which maybe is not the best way of writing 32 bit values...
  printf("%p: %08x (=%08x)\n", address, *address, intspace);
  return 0;
}
