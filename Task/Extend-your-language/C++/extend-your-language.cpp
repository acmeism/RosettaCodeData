// Header file "if2.hpp"
#ifndef if2_HPP_
#define if2_HPP_

#define if2(first, second, both_true, first_true, second_true, neither_true) \
    const uint32_t value = ( first ? 0 : 2 ) + ( second ? 0 : 1 );           \
    switch ( value ) {                                                       \
    	case 0: both_true; break;                                            \
    	case 1: first_true; break;                                           \
    	case 2: second_true; break;                                          \
    	case 3: neither_true; break;                                         \
    }

#endif

// Main file
#include <cstdint>
#include <iostream>

#include "if2.hpp"

int main() {
	for ( uint32_t N = 10; N <= 20; ++N ) {
		std::cout << N;
		if2(N % 2 == 0, N % 3 == 0,
			std::cout << " is    divisible by both 2 and 3" << "\n",
			std::cout << " is    divisible by 2, but not by 3" << "\n",
			std::cout << " is    divisible by 3, but not by 2" << "\n",
			std::cout << " isn't divisible by 2, nor by 3" << "\n");
	}
}
