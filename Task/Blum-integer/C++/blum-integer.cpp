#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

bool is_prime_type_3(const int32_t number) {
	if ( number < 2 ) return false;
	if ( number % 2 == 0 ) return false;
	if ( number % 3 == 0 ) return number == 3;

	for ( int divisor = 5; divisor * divisor <= number; divisor += 2 ) {
		if ( number % divisor == 0 ) { return false; }
	}

	return number % 4 == 3;
}

int32_t least_prime_factor(const int32_t number) {
	if ( number == 1 ) { return 1; }
    if ( number % 3 == 0 ) { return 3; }
    if ( number % 5 == 0 ) { return 5; }

    for ( int divisor = 7; divisor * divisor <= number; divisor += 2 ) {
		if ( number % divisor == 0 ) { return divisor; }
	}

	return number;
}

int main() {
	int32_t blums[50];
	int32_t blum_count = 0;
	int32_t last_digit_counts[10] = {};
	int32_t number = 1;

	while ( blum_count < 400'000 ) {
		const int32_t prime = least_prime_factor(number);
		if ( prime % 4 == 3 ) {
			const int32_t quotient = number / prime;
			if ( quotient != prime && is_prime_type_3(quotient) ) {
				if ( blum_count < 50 ) {
					blums[blum_count] = number;
				}
				last_digit_counts[number % 10] += 1;
				blum_count += 1;
				if ( blum_count == 50 ) {
					std::cout << "The first 50 Blum integers:" << std::endl;
					for ( int32_t i = 0; i < 50; ++i ) {
						std::cout << std::setw(3) << blums[i] << ( ( i % 10 == 9 ) ? "\n" : " " );
					}
					std::cout << std::endl;
				} else if ( blum_count == 26'828 || blum_count % 100'000 == 0 ) {
					std::cout << "The " << std::setw(6) << blum_count << "th Blum integer is: "
						<< std::setw(7) << number << std::endl;
					if ( blum_count == 400'000 ) {
						std::cout << "\nPercent distribution of the first 400000 Blum integers:" << std::endl;
						for ( const int32_t& i : { 1, 3, 7, 9 } ) {
							std::cout << "    " << std::setw(6) << std::setprecision(5)
								<< (double) last_digit_counts[i] / 4'000 << "% end in " << i << std::endl;
						}
					}
				}
			}
		}
		number += ( number % 5 == 3 ) ? 4 : 2;
	}
}
