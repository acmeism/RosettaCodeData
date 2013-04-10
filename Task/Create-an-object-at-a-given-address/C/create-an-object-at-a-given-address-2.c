// This is a port variable located at address 0x100
#define PORT_A (*(volatile uint32_t*)0x100)

void main()
{
  uint32_t dat;

  PORT_A ^= 0x01;   // Toggle bit 0 of PORT_A
  dat = PORT_A;     // Read PORT_A
  addr = &PORT_A;   // addr = 0x100

  while (1)
  {
  }
}
