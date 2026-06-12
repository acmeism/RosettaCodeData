#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

std::vector<uint32_t> digit_vector(const uint32_t& number) {
  std::vector<uint32_t> digits;
  uint32_t n = number;
  while ( n > 0 ) {
    digits.emplace_back(n % 10);
    n /= 10;
  }
  return digits;
}

bool all_divisible(const uint32_t& n, const std::vector<uint32_t>& digits) {
  for ( const uint32_t& digit : digits ) {
    if ( digit == 0 || n % digit > 0 ) {
      return false;
    }
  }
  return true;
}

int main() {
  std::vector<uint32_t> result;

  for ( uint32_t n = 1; n < 1'000; ++n ) {
    std::vector<uint32_t> digits = digit_vector(n);
    if ( all_divisible(n, digits) ) {
      uint32_t product = 1;
      for ( const uint32_t& digit : digits ) {
        product *= digit;
      }
      if ( n % product > 0 ) {
        result.emplace_back(n);
      }
    }
  }

  std::cout << "Numbers < 1,000 divisible by their digits, but not by the product thereof:" << std::endl;
  for ( uint32_t i = 0; i < result.size(); ++i ) {
    std::cout << std::setw(3) << result[i] << ( i % 9 == 8 ? "\n" : " " );
  }
}
