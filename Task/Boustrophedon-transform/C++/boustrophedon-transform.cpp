#include <cstdint>
#include <functional>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

std::vector<uint32_t> primes;
std::unordered_map<uint32_t, uint64_t> fibonacci_cache;
std::unordered_map<uint32_t, uint64_t> factorial_cache;

void sieve_primes(const uint32_t& limit) {
	primes.emplace_back(2);
	const uint32_t half_limit = ( limit + 1 ) / 2;
	std::vector<bool> composite(half_limit);
	for ( uint32_t i = 1, p = 3; i < half_limit; p += 2, ++i ) {
		if ( ! composite[i] ) {
			primes.emplace_back(p);
			for ( uint32_t a = i + p; a < half_limit; a += p ) {
				composite[a] = true;
			}
		}
	}
}

uint64_t one_one(const uint32_t& number) {
	return ( number == 0 ) ? 1 : 0;
}

uint64_t all_ones(const uint32_t& number) {
	return 1;
}

uint64_t alternating(const uint32_t& number) {
	return ( number % 2 == 0 ) ? +1 : -1;
}

uint64_t prime(const uint32_t& number) {
	return primes[number];
}

uint64_t fibonacci(const uint32_t& number) {
	if ( ! fibonacci_cache.contains(number) ) {
		if ( number == 0 || number == 1 ) {
			fibonacci_cache[number] = 1;
		} else {
			fibonacci_cache[number] = fibonacci(number - 2) + fibonacci(number - 1);
		}
	}
	return fibonacci_cache[number];
}

uint64_t factorial(const uint32_t& number) {
	if ( ! factorial_cache.contains(number) ) {
		uint64_t value = 1;
		for ( uint32_t i = 2; i <= number; ++i ) {
			value *= i;
		}
		factorial_cache[number] = value;
	}
	return factorial_cache[number];
}

class Boustrophedon_Iterator {
public:
	Boustrophedon_Iterator(const std::function<uint64_t(uint32_t)>& aSequence) : sequence(aSequence) {}

	uint64_t next() {
		index += 1;
		return transform(index, index);
	}

private:
	uint64_t transform(const uint32_t& k, const uint32_t& n) {
		if ( n == 0 ) {
			return sequence(k);
		}

		if ( ! cache[k].contains(n) ) {
			 const uint64_t value = transform(k, n - 1) + transform(k - 1, k - n);
			 cache[k][n] = value;
		}
		return cache[k][n];
	}

	int32_t index = -1;
	std::function<uint64_t(uint32_t)> sequence;
	std::unordered_map<uint32_t, std::unordered_map<uint32_t, uint64_t>> cache;
};

void display(const std::string& title, const std::function<uint64_t(uint32_t)>& sequence) {
	std::cout << title << std::endl;
	Boustrophedon_Iterator iterator = Boustrophedon_Iterator(sequence);
	for ( uint32_t i = 1; i <= 15; ++i ) {
		std::cout << iterator.next() << " ";
	}
	std::cout << std::endl << std::endl;
}

int main() {
	sieve_primes(8'000);

	display("One followed by an infinite series of zeros -> A000111", one_one);
	display("An infinite series of ones -> A000667", all_ones);
	display("(-1)^n: alternating 1, -1, 1, -1 -> A062162", alternating);
	display("Sequence of prime numbers -> A000747", prime);
	display("Sequence of Fibonacci numbers -> A000744", fibonacci);
	display("Sequence of factorial numbers -> A230960", factorial);
}
