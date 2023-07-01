#include <iostream>
#include <cmath>
#include <vector>

class Splitmix64 {
public:
	Splitmix64() { state = 0; }
	Splitmix64(const uint64_t seed) : state(seed) {}

	void seed(const uint64_t seed) {
		state = seed;
	}

	uint64_t next_int() {
		uint64_t z = ( state += 0x9e3779b97f4a7c15 );
		z = ( z ^ ( z >> 30 ) ) * 0xbf58476d1ce4e5b9;
		z = ( z ^ ( z >> 27 ) ) * 0x94d049bb133111eb;
		return z ^ ( z >> 31 );
	}

	double next_float() {
	    return next_int() / twoPower64;
	}

private:
	uint64_t state;
	const double twoPower64 = pow(2.0, 64);
};

int main() {
	Splitmix64 random;
	random.seed(1234567);
	for ( int32_t i = 0; i < 5; ++i ) {
		std::cout << random.next_int() << std::endl;
	}
	std::cout << std::endl;

	Splitmix64 rand(987654321);
	std::vector<uint32_t> counts(5, 0);
	for ( int32_t i = 0; i < 100'000; ++i ) {
		uint32_t value = floor(rand.next_float() * 5.0);
		counts[value] += 1;
	}

	for ( int32_t i = 0; i < 5; ++i ) {
		std::cout << i << ": " << counts[i] << "   ";
	}
	std::cout << std::endl;
}
