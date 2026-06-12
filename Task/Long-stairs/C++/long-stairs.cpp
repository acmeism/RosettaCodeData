#include <cstdint>
#include <iomanip>
#include <iostream>
#include <random>

std::random_device random;
std::mt19937 generator(random());

int main() {
	const uint32_t trial_count = 10'000;
	double total_seconds = 0.0;
	double total_steps = 0.0;

	std::cout << "Seconds    Steps behind    Steps ahead" << std::endl;
	std::cout << "-------    ------------    -----------" << std::endl;

	for ( uint32_t trial = 0; trial < trial_count; ++trial ) {
		uint32_t steps_behind = 0;
		uint32_t step_count = 100;
		uint32_t seconds = 0;
		while ( steps_behind < step_count ) {
			steps_behind++;
			for ( uint32_t wizard = 0; wizard < 5; ++wizard ) {
				std::uniform_int_distribution<uint32_t> distribution(0, step_count);
				if ( distribution(generator) < steps_behind ) {
					steps_behind++;
				}
				step_count++;
			}
			seconds++;

			if ( trial == 0 && seconds >= 600 && seconds <= 609 ) {
				std::cout << std::setw(5) << seconds << std::setw(14) << steps_behind
						  << std::setw(15) << step_count - steps_behind << std::endl;
			}
		}
		total_seconds += seconds;
		total_steps += step_count;
	}

	std::cout << "\n" << "Average time taken in seconds: " << total_seconds / trial_count << std::endl;
	std::cout << "Average final length of the staircase: " << total_steps / trial_count << std::endl;
}
