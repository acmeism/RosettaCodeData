#include <bitset>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

const uint32_t limit = 1'000'000'000;
std::bitset<limit + 1> primes;

void sieve_primes(uint32_t limit) {
	primes.set();
	primes.reset(0); primes.reset(1);

	for ( uint32_t p = 2; p * p <= limit; ++p ) {
		if ( primes.test(p) ) {
			for ( uint32_t i = p * p; i <= limit; i += p ) {
				primes.reset(i);
			}
		}
	}
}

int main() {
	sieve_primes(limit);

	uint32_t target = 10;
	uint32_t count = 0;
    bool last = false;
    bool first = true;

    for ( uint32_t index = 5; index <= limit; index += 2 ) {
        last = first;
        first = primes[index];
        if ( last && first ) {
            count += 1;
        }
        if ( index + 1 == target ) {
        	std::cout << std::setw(8) << count << " twin primes below " << index + 1 << std::endl;
        	target *= 10;
        }
    }
}
