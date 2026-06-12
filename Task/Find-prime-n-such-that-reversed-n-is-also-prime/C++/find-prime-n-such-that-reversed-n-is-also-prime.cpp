#include <cstdint>
#include <iostream>

bool is_prime(uint32_t number) {
  if ( number % 2 == 0 ) {
    return number == 2;
  }
  int k = 3;
  while ( k * k <= number ) {
    if ( number % k == 0 ) {
      return false;
    }
    k += 2;
  }
  return true;
}

bool is_reversed_prime(uint32_t number) {
  if ( ! is_prime(number) ) {
    return false;
  }

  uint32_t reversed = 0;
  while ( number > 0 ) {
    reversed = reversed * 10 + number % 10;
    number /= 10;
  }
  return is_prime(reversed);
}

int main() {
  for ( int32_t n = 2; n < 500; ++n ) {
    if ( is_reversed_prime(n) ) {
      std::cout << n << " ";
    }
  }
  std::cout << std::endl;
}
