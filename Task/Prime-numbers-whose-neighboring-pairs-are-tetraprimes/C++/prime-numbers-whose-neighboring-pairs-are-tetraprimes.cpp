#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <string>
#include <vector>

std::vector<uint32_t> primes;

void sieve_primes(const uint32_t& limit) {
	std::vector<bool> marked_prime(limit + 1, true);

	for ( uint32_t i = 2; i * i <= limit; ++i ) {
		if ( marked_prime[i] ) {
			for ( uint32_t j = i * i; j <= limit; j += i ) {
				marked_prime[j] = false;
			}
		}
	}

	for ( uint32_t i = 2; i <= limit; ++i ) {
		if ( marked_prime[i] ) {
			primes.emplace_back(i);
		}
	}
}

uint32_t largest_less_than(const uint32_t& n) {
    auto lower = std::lower_bound(primes.begin(), primes.end(), n);
    return primes[std::distance(primes.begin(), lower) - 1];
}

uint32_t median(const std::vector<uint32_t>& list) {
	if ( list.size() % 2 == 0 ) {
		return ( list[list.size() / 2 - 1] + list[list.size() / 2] ) / 2;
	}
	return list[list.size() / 2];
}

bool is_tetraPrime(uint32_t n) {
    uint32_t count = 0;
    uint32_t previous_factor = 1;
    for ( uint32_t prime : primes ) {
        uint64_t limit = prime * prime;
        if ( count == 0 ) {
            limit *= limit;
        } else if ( count == 1 ) {
            limit *= prime;
        }
        if ( limit <= n ) {
            while ( n % prime == 0 ) {
                if ( count == 4 || prime == previous_factor ) {
                	return false;
                }
                count++;
                n /= prime;
                previous_factor = prime;
            }
        } else {
            break;
        }
    }

    if ( n > 1 ) {
        if ( count == 4 || n == previous_factor ) {
        	return false;
        }
        count++;
    }
    return count == 4;
}

int main() {
	sieve_primes(10'000'000);

	const uint32_t largest_prime_5 = largest_less_than(100'000);
	const uint32_t largest_prime_6 = largest_less_than(1'000'000);
	const uint32_t largest_prime_7 = primes.back();
	std::vector<uint32_t> tetras_preceeding;
	std::vector<uint32_t> tetras_following;
	uint32_t sevens_preceeding = 0;
	uint32_t sevens_following = 0;
	uint32_t limit = 100'000;

	for ( const uint32_t& prime : primes ) {
	    if ( is_tetraPrime(prime - 1) && is_tetraPrime(prime - 2) ) {
	        tetras_preceeding.emplace_back(prime);
	        if ( ( prime - 1 ) % 7 == 0 || ( prime - 2 ) % 7 == 0 ) {
	        	sevens_preceeding++;
	        }
	    }

	    if ( is_tetraPrime(prime + 1) && is_tetraPrime(prime + 2) ) {
	        tetras_following.emplace_back(prime);
	        if ( ( prime + 1 ) % 7 == 0 || ( prime + 2 ) % 7 == 0 ) {
	        	sevens_following++;
	        }
	    }

	    if ( prime == largest_prime_5 || prime == largest_prime_6 || prime == largest_prime_7 ) {
	        for ( uint32_t i = 0; i <= 1; ++i ) {
	            std::vector<uint32_t> tetras = ( i == 0 ) ? tetras_preceeding : tetras_following;
	            const uint64_t size = tetras.size();
	            const uint32_t sevens = ( i == 0 ) ? sevens_preceeding : sevens_following;
	            const std::string text = ( i == 0 ) ? "preceding" : "following";

	            std::cout << "Found " << size << " primes under " << limit << " whose "
	            		  << text << " neighboring pair are tetraprimes";
	            if ( prime == largest_prime_5 ) {
	                std::cout << ":" << std::endl;
	                for ( uint64_t j = 0; j < size; ++j ) {
	                	std::cout << std::setw(7) << tetras[j] << ( ( j % 10 == 9 ) ? "\n" : "" );
	                }
	                std::cout << std::endl;
	            }
	            std::cout << std::endl;
	            std::cout << "of which " << sevens << " have a neighboring pair one of whose factors is 7."
	            		  << std::endl << std::endl;

	            std::vector<uint32_t> gaps(size - 1, 0);
	            for ( uint64_t k = 0; k < size - 1; ++k ) {
	            	gaps[k] = tetras[k + 1] - tetras[k];
	            }
	            std::sort(gaps.begin(), gaps.end());
	            const uint32_t minimum = gaps.front();
	            const uint32_t maximum = gaps.back();
	            const uint32_t middle = median(gaps);
	            std::cout << "Minimum gap between those " << size << " primes: " << minimum << std::endl;
	            std::cout << "Median  gap between those " << size << " primes: " << middle << std::endl;
	            std::cout << "Maximum gap between those " << size << " primes: " << maximum << std::endl;
	            std::cout << std::endl;
	        }
	        limit *= 10;
	    }
	}
}
