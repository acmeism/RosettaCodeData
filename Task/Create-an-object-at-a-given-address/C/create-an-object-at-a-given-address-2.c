#include <stdint.h>
#include <stddef.h>

// This is a port variable located at address 0x100
#define PORT_A (*(volatile uint32_t*)0x100)

int main()
{
  uint32_t dat;
  size_t addr;

  PORT_A ^= 0x01;   // Toggle bit 0 of PORT_A
  dat = PORT_A;     // Read PORT_A
  addr = &PORT_A;   // addr = 0x100

  return 0;
}
