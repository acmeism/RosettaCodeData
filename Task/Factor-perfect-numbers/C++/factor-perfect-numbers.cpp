#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>
#include <set>
#include <string>
#include <vector>

std::map<uint32_t, uint32_t> cache{ };

std::string vector_to_string(const std::vector<uint32_t>& vec) {
	std::string result = "[";
	for ( uint32_t i = 0; i < vec.size() - 1; ++i ) {
		result += std::to_string(vec[i]) + ", ";
	}
	result += std::to_string(vec.back()) + "]";
	return result;
}

std::vector<uint32_t> divisors(const uint32_t& number) {
	std::set<uint32_t> divisors{ };

	uint32_t divisor = 1;
	while ( divisor * divisor <= number ) {
		if ( number % divisor == 0 ) {
			divisors.insert(divisor);
			divisors.insert(number / divisor);
		}
		divisor += 1;
	}

	std::vector<uint32_t> result(divisors.begin(), divisors.end());
	return result;
}

std::vector<std::vector<uint32_t>> more_multiples(const std::vector<uint32_t>& to_vec,
												  const std::vector<uint32_t>& from_vec) {
	std::vector<std::vector<uint32_t>> result{ };

	for ( const uint32_t& from : from_vec ) {
	   if ( from > to_vec.back() && from % to_vec.back() == 0 ) {
		   std::vector<uint32_t> to_vec_copy = to_vec;
		   to_vec_copy.emplace_back(from);
		   result.emplace_back(to_vec_copy);
	   }
	}

	std::vector<std::vector<uint32_t>> result_copy = result;
	for ( const std::vector<uint32_t>& vec : result_copy ) {
		for ( const std::vector<uint32_t>& more : more_multiples(vec, from_vec) ) {
			result.emplace_back(more);
		}
	}

	return result;
}

uint32_t erdös_factor_count(const uint32_t& number) {
	if ( ! cache.contains(number) ) {
		uint32_t factorCount = 0;
		const std::vector<uint32_t> divs = divisors(number);
		for ( uint32_t i = 1; i < divs.size() - 1; ++i ) {
			factorCount += erdös_factor_count(number / divs[i]);
		}
		factorCount += 1;
		cache[number] = factorCount;
	}

	return cache[number];
}

int main() {
    const uint32_t test = 48;

	const std::vector<uint32_t> singleton(1, 1);
	std::vector<std::vector<uint32_t>> multiples = more_multiples(singleton, divisors(test));

	std::set<std::vector<uint32_t>> result_one{ };
	for ( std::vector<uint32_t> vec : multiples ) {
		if ( vec.back() != test ) {
			vec.emplace_back(test);
		}
		result_one.insert(vec);
	}

	std::cout << result_one.size() << " sequences using the first definition:" << std::endl;
	uint32_t count = 0;
	for ( const std::vector<uint32_t>& vec : result_one ) {
		const std::string vector_string = vector_to_string(vec);
		std::cout << vector_string << ( count++ % 4 == 3 ? "\n" : std::string(23 - vector_string.size(), ' ') );
	}
	std::cout << std::endl;

	std::cout << result_one.size() << " sequences using the second definition:" << std::endl;
	std::set<std::vector<uint32_t>> result_two{ };
	for ( std::vector<uint32_t> vec : result_one ) {
		for ( uint32_t i = 1; i < vec.size(); ++i ) {
			vec[i - 1] = vec[i] / vec[i - 1];
		}
		vec.pop_back();
		result_two.insert(vec);
	}

	count = 0;
	for ( const std::vector<uint32_t>& vec : result_two ) {
		const std::string vector_string = vector_to_string(vec);
		std::cout << vector_string << ( count++ % 4 == 3 ? "\n" : std::string(23 - vector_string.size(), ' ') );
	}
	std::cout << std::endl;

	std::cout << "OEIS A163272: 0 1 ";
	for ( uint32_t n = 2; n < 2'400'000; ++n ) {
		if ( erdös_factor_count(n) == n ) {
			std::cout << n << " ";
		}
	}
	std::cout << std::endl;
}
