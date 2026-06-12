#include <cstdint>
#include <iomanip>
#include <iostream>

bool is_prime(const uint32_t& number) {
   if ( number % 2 == 0 ) {
      return number == 2;
   }
   uint32_t k = 3;
   while ( k * k <= number ) {
      if ( number % k == 0 ) {
         return false;
      }
      k += 2;
   }
   return true;
}

int main() {
   uint32_t prime_pi = 0;
   uint32_t n = 1;
   while ( prime_pi < 22 ) {
      std::cout << std::setw(2) << prime_pi << ( ( n % 10 == 0 ) ? "\n" : " " );
      n += 1;
      if ( is_prime(n) ) {
         prime_pi += 1;
      }
   }
}
