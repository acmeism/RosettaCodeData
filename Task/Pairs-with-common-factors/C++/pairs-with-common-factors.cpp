#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <vector>

std::vector<uint32_t> totients;
std::vector<uint32_t> primes;

void listTotients(const uint32_t& maximum) {
  totients.resize(maximum + 1);
  std::iota(totients.begin(), totients.end(), 0);

  for ( uint32_t i = 2; i <= maximum; ++i ) {
    if ( totients[i] == i ) {
      totients[i] = i - 1;
      for ( uint32_t j = i * 2; j <= maximum; j += i ) {
        totients[j] = ( totients[j] / i ) * ( i - 1 );
      }
    }
  }
}

void listPrimeNumbers(const uint32_t& maximum) {
  const uint32_t halfMaximum = ( maximum + 1 ) / 2;
  std::vector<bool> composite(halfMaximum, false);

  for ( uint32_t i = 1, p = 3; i < halfMaximum; p += 2, ++i ) {
    if ( ! composite[i] ) {
      for ( uint32_t j = i + p; j < halfMaximum; j += p ) {
        composite[j] = true;
      }
    }
  }

  primes.push_back(2);
  for ( uint32_t i = 1, p = 3; i < halfMaximum; p += 2, ++i ) {
    if ( ! composite[i] ) {
      primes.push_back(p);
    }
  }
}

int main() {
  const uint32_t maximum = 1'000'000;
  listPrimeNumbers(maximum);
  listTotients(maximum);
  std::vector<uint64_t> pairsCount(maximum + 1, 0);
  uint64_t totientSum = 0;

  for ( uint64_t number = 1; number <= maximum; ++number ) {
    totientSum += totients[number];
    if ( std::binary_search(primes.begin(), primes.end(), number) ) {
      pairsCount[number] = pairsCount[number - 1];
    } else {
      pairsCount[number] = ( number * ( number - 1 ) >> 1 ) - totientSum + 1;
    }
  }

  std::cout << "The first one hundred terms of the number of pairs with common factors:" << std::endl;
  for ( uint32_t number = 1; number <= 100; ++number ) {
    std::cout << std::setw(4) << pairsCount[number] << ( ( number % 10 == 0 ) ? "\n" : " " );
  }
  std::cout << std::endl;

  uint32_t term = 1;
  while ( term <= maximum ) {
    std::cout << std::left << std::setw(14)
                  << "Term " + std::to_string(term) + ": " << pairsCount[term] << std::endl;
    term *= 10;
  }
}
