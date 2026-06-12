#include <cstdint>
#include <iostream>

uint64_t reverse_digits(uint64_t n) {
    uint64_t result = 0;
    while ( n > 0 ) {
        result = n % 10 + result * 10;
        n /= 10;
    }
    return result;
}

int main() {
	uint32_t power = 10;
	for ( uint32_t n = 2; n <= 9; ++n ) {
	    const uint64_t low = power * 9;
	    power *= 10;
	    const uint64_t high = power - 1;
	    bool found = false;
	    for ( uint64_t i = high; i >= low && ! found; --i ) {
	        const uint64_t j = reverse_digits(i);
	        uint64_t possible_product = i * power + j;
	        // 'high_copy' cannot be even nor end in 5 to produce a product ending in 9
	        uint64_t high_copy = high;
	        while ( high_copy > low ) {
	            if ( high_copy % 10 != 5 ) {
	                const uint64_t divisor = possible_product / high_copy;
	                if ( divisor > high ) {
	                	break;
	                }
	                if ( possible_product % high_copy == 0 ) {
	                	std::cout << "Largest palindromic product of two " << n << "-digit integers: ";
	                    std::cout << high_copy << " x " << divisor << " = " << possible_product << std::endl;
	                    found = true;
	                    break;
	                }
	            }
	            high_copy -= 2;
	        }
	    }
	}
}
