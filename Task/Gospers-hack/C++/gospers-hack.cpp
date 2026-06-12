#include <cstdint>
#include <iostream>

uint32_t gospers_hack(const uint32_t& n) {
  const uint32_t c = n & -n;
  const uint32_t r = n + c;
  return ( ( ( r ^ n ) >> 2 ) / c ) | r;
}

int main() {
  for ( uint32_t start : { 1, 3, 7, 15 } ) {
    std::cout << start << ": ";

    for ( uint32_t i = 0; i < 10; ++i ) {
      start = gospers_hack(start);
      std::cout << start << " ";
    }
    std::cout << std::endl;
  }
}
