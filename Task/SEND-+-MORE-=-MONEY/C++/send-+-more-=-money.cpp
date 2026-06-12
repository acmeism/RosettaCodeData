#include <cstdint>
#include <iostream>

int main() {
	const uint32_t m = 1;
	for ( uint32_t s = 8; s < 10; ++s ) {
		for ( uint32_t e = 0; e < 10; ++e ) {
			if ( e == m || e == s ) { continue; }
			for ( uint32_t n = 0; n < 10; ++n ) {
				if ( n == m || n == s || n == e ) { continue; }
				for ( uint32_t d = 0; d < 10; ++d ) {
					if ( d == m || d == s || d == e || d == n ) { continue; }
					for ( uint32_t o = 0; o < 10; ++o ) {
						if ( o == s || o == e || o == n || o == d || o == m ) { continue; }
						for ( uint32_t r = 0; r < 10; ++r ) {
							if ( r == s || r == e || r == n || r == d || r == m || r == o ) { continue; }
							for ( uint32_t y = 0; y < 10; ++y ) {
								if ( y == s || y == e || y == n || y == d || y == m || y == 0 ) { continue; }
								if ( 1'000 * s + 100 * e + 10 * n + d + 1'000 * m + 100 * o + 10 * r + e
									== 10'000 * m + 1'000 * o + 100 * n + 10 * e + y ) {
									std::cout << s << e << n << d << " + " << m << o << r << e
											  << " = " << m << o << n << e << y << std::endl;
								}
							}
						}
					}
				}
			}
		}
	}
}
