#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

const int32_t limit = 50'000;

std::vector<int32_t> divisors;
std::vector<int32_t> subtractors;
std::vector<std::vector<std::string>> minimums;

template <typename T>
void print_vector(const std::vector<T>& list) {
	for ( uint64_t i = 0; i < list.size(); ++i ) {
		std::cout << list[i];
		if ( i < list.size() - 1 ) {
			std::cout << ", ";
		}
	}
}

// Assumes that numbers are presented in ascending order up to 'limit'.
void minimum_steps(int32_t n) {
    if ( n == 1 ) {
        return;
    }

    int32_t minimum = limit;
	int32_t p = 0;
	int32_t q = 0;
	std::string operator_symbol = "";
	for ( int32_t divisor : divisors ) {
		if ( n % divisor == 0 ) {
		    int32_t d = n / divisor;
			int32_t steps = minimums[d].size() + 1;
			if ( steps < minimum ) {
				minimum = steps;
				p = d;
				q = divisor;
				operator_symbol = "/";
			}
		}
	}

	for ( int32_t subtractor : subtractors ) {
		int32_t d = n - subtractor;
		if ( d >= 1 ) {
			int32_t steps = minimums[d].size() + 1;
			if ( steps < minimum ) {
				minimum = steps;
				p = d;
				q = subtractor;
				operator_symbol = "-";
			}
		}
	}

	minimums[n].emplace_back(operator_symbol + std::to_string(q) + " -> " + std::to_string(p));
	minimums[n].insert(minimums[n].end(), minimums[p].begin(), minimums[p].end());
}

int main() {
	for ( int32_t item : { 0, 1 } ) {
	    divisors = { 2, 3 };
	    subtractors = { item + 1 };
	    minimums = std::vector(limit + 1, std::vector<std::string>(0));
	    std::cout << "With: Divisors: { "; print_vector<int32_t>(divisors);
	    std::cout << " }, Subtractors: { "; print_vector<int32_t>(subtractors); std::cout << " } =>" << std::endl;
	    std::cout << "  Minimum number of steps to diminish the following numbers down to 1 is:" << std::endl;
	    for ( int32_t i = 1; i < limit; ++i ) {
	        minimum_steps(i);
	        if ( i <= 10 ) {
	            int32_t steps = minimums[i].size();
	            const std::string plural = ( steps == 1 ) ? " : " : "s: ";
	            std::cout << "    " << std::setw(2) << i << ": " << steps << " step" + plural;
	            print_vector<std::string>(minimums[i]); std::cout << std::endl;
	        }
	    }

	    for ( int32_t lim : { 2'000, 20'000, 50'000 } ) {
		   uint64_t max = 0;
		   for ( int32_t j = 1; j <= lim; ++j ) {
			   uint64_t m = minimums[j].size();
			   if ( m > max ) {
				   max = m;
			   }
		   }
		   std::vector<int32_t> maxs;
		   for ( int32_t j = 1; j <= lim; ++j ) {
			   if ( minimums[j].size() == max ) {
				   maxs.emplace_back(j);
			   }
		   }

		   int32_t size = maxs.size();
		   std::string verb1  = ( size == 1 ) ? "is" : "are";
		   std::string verb2  = ( size == 1 ) ? "has" : "have";
		   std::string plural = ( size == 1 ) ? "" : "s";
		   std::cout << "  There " << verb1 << " " << size << " number" << plural << " in the range 1 - " << lim
				     << " that " << verb2 << " maximum 'minimal steps' of " << max << ":" << std::endl;
		   std::cout << "  [ "; print_vector<int32_t>(maxs); std::cout << " ]" << std::endl;
	   }
	   std::cout << std::endl;
	}
}
