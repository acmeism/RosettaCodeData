#include <stdio.h>
#include <stdint.h>

int main() {
  uint32_t doorBytes[4] = {0};

  for (uint32_t i = 1; i <= 100; ++i)
    for (uint32_t j = i - 1; j <= 99; j += i)
      doorBytes[j % 4] ^= (uint32_t)1 << j / 4;

  for (uint32_t i = 0; i <= 99; doorBytes[i++ % 4] >>= 1)
    if (doorBytes[i % 4] & 1)
      printf("door %d is open\n", i + 1);
}
