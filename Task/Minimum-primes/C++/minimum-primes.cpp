#include <algorithm>
#include <cstdint>
#include <iostream>
#include <iterator>
#include <vector>

uint32_t next_prime(uint32_t number) {
    uint32_t divisor = 2;
    while ( divisor * divisor <= number ) {
        if ( number % divisor == 0 ) {
          number++;
          divisor = 2;
        } else {
          divisor++;
        }
    }
    return number;
}

int main() {
  const std::vector<uint32_t> numbers1{  5, 45, 23, 21, 67 };
  const std::vector<uint32_t> numbers2{ 43, 22, 78, 46, 38 };
  const std::vector<uint32_t> numbers3{  9, 98, 12, 54, 53 };

  std::vector<uint32_t> primes{};
  for ( uint32_t n = 0; n < 5; ++n ) {
      const uint32_t max = std::max({ numbers1[n], numbers2[n], numbers3[n] });
      primes.emplace_back(next_prime(max));
  }

  std::copy(primes.begin(), primes.end(), std::ostream_iterator<uint32_t>(std::cout, " "));
}
