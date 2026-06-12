#include <cstdint>
#include <iostream>
#include <vector>

int main() {
	std::vector<uint32_t> result;
	uint32_t number = 3;
	while ( result.size() < 7 ) {
	    uint32_t collatz = number;
	    while ( collatz != 1 ) {
	        collatz = ( collatz % 2 == 0 ) ? collatz / 2 : 3 * collatz + 1;
	        if ( collatz % number == 0 ) {
	            result.emplace_back(number);
	            collatz = 1;
	        }
	    }
	    number += 2;
	}

	std::cout << "The first seven self-contained numbers are: ";
	for ( const uint32_t number : result ) std::cout << number << " ";
	std::cout << std::endl;
}
