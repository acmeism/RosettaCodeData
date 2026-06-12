#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

int main() {
	std::vector<uint32_t> prime_measures(1'000, 0);
	uint32_t prime_measure_index = 0;

	prime_measures[0] = 1;
	prime_measure_index += 1;

	for ( uint32_t next_number = 2; next_number <= 5'000; ++next_number ) {
	    bool found_prime_measure = true;

	    for ( uint32_t start_index = 0; start_index <= prime_measure_index - 1; ++start_index ) {
	        uint32_t sum = prime_measures[start_index];
	        for ( uint32_t end_index = start_index + 1; end_index <= prime_measure_index - 1; ++end_index ) {
	            sum += prime_measures[end_index];
	            if ( sum > next_number ) {
	            	break;
	            }
	            if ( sum == next_number ) {
	                found_prime_measure = false;
	                break;
	            }
	        }
	        if ( ! found_prime_measure ) {
	        	break;
	        }
	    }

	    if ( found_prime_measure ) {
	        prime_measures[prime_measure_index] = next_number;
	        prime_measure_index += 1;
	        if ( prime_measure_index >= 1'000 ) {
	        	break;
	        }
	    }
	}

	std::cout << "First 100:" << std::endl;
	for ( uint32_t i = 0; i < 100; ++i ) {
	    std::cout << std::setw(3) << prime_measures[i] << ( i % 10 == 9 ? "\n" : " " );
	}

	std::cout << "\n" << "One Thousandth: " << prime_measures[999] << std::endl;
}
