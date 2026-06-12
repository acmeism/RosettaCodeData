#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

int main() {
	const uint32_t N = 2'000;
	std::vector<bool> idoneal(N, true);

	for ( uint32_t a = 1; a < std::sqrt(N / 3); ++a ) {
		uint32_t p = a * ( a + 1 );
		for ( uint32_t b = a + 1; b < N / ( 3 * a ); ++b ) {
			uint32_t n = p + ( a + b ) * ( b + 1 );
			while ( n < N ) {
				idoneal[n] = false;
				n += a + b;
			}
			p += a;
		}
	}

	for ( uint32_t i = 1, count = 0; i < N; ++i ) {
		if ( idoneal[i] ) {
			count++;
			std::cout << std::setw(5) << i << ( ( count % 13 == 0 ) ? "\n" : "" );
		}
	}
}
