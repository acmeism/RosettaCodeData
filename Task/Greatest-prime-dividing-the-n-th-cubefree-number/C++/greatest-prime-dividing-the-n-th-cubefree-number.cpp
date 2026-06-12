#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

std::vector<uint32_t> prime_factors(uint32_t n) {
    std::vector<uint32_t> factors = { };
    while ( n % 2 == 0 ) {
    	factors.emplace_back(2);
    	n /= 2;
    }
    for ( uint32_t i = 3; i <= std::sqrt(n); i += 2 ) {
    	while ( n % i == 0 ) {
    		factors.emplace_back(i);
    		n /= i;
    	}
    }
    if ( n > 2 ) {
    	factors.emplace_back(n);
    }
    return factors;
}

int main() {
	const uint32_t maximum = 10000000;
	uint32_t count = 1;
	uint32_t i = 2;
	const uint32_t lower_limit = 100;
	uint32_t upper_limit = 1000;
	std::vector<uint32_t> first_hundred = { 1 };

	while ( count < maximum ) {
	    bool cube_free = false;
	    std::vector<uint32_t> factors = prime_factors(i);

	    if ( factors.size() < 3 ) {
	        cube_free = true;
	    } else {
	    	cube_free = true;
	    	for ( uint32_t i = 2; i < factors.size(); ++i ) {
	    		if ( factors[i - 2] == factors[i - 1] && factors[i - 1] == factors[i] ) {
	    			cube_free = false;
	    			break;
	    		}
	    	}
	    }

	    if ( cube_free ) {
	    	if ( count < lower_limit ) {
	    		first_hundred.emplace_back(factors.back());
	    	}
	    	count += 1;
	    	if ( count == lower_limit ) {
	    		std::cout << "The first " << lower_limit << " terms of a370833 are:" << "\n";
	    		for ( uint32_t i = 0; i < 100; ++i ) {
	    			std::cout << std::setw(3) << first_hundred[i] << ( i % 10 == 9 ? "\n" : " " );
	    		}
	    		std::cout << "\n";
	    	} else if ( count == upper_limit ) {
	    		std::cout << "The " << count << "th term of a370833 is " << factors.back() << "\n";
	    		upper_limit *= 10;
	    	}
	    }

	    i += 1;
	 }
}
