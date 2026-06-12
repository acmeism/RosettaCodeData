#include <cstdint>
#include <iostream>

uint32_t digit_count(const uint32_t& number, const uint32_t& digit) {
    uint32_t count = 0;
    uint32_t n = number;
    while ( n > 0 ) {
        if ( n % 10 == digit ) {
        	count++;
        }
        n /= 10;
    }
    return count;
}

int main() {
	for ( uint32_t i = 1; i < 1'000; ++i ) {
	    if ( digit_count(i, 1) == 2 ) {
	    	std::cout << i << " ";
	    }
	}
	std::cout << std::endl;
}
