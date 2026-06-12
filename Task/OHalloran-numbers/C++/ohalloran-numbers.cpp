#include <cstdint>
#include <iostream>
#include <vector>

int main() {
	const uint32_t maximum_area = 1'000;
	const uint32_t half_maximum_area = maximum_area / 2;

	std::vector<uint32_t> ohalloran_numbers(half_maximum_area, true);

	for ( uint32_t length = 1; length < maximum_area; ++length ) {
		for ( uint32_t width = 1; width < half_maximum_area; ++width ) {
			for ( uint32_t height = 1; height < half_maximum_area; ++height ) {
				uint32_t half_area = length * width + length * height + width * height;
				if ( half_area < half_maximum_area ) {
					ohalloran_numbers[half_area] = false;
				}
			}
		}
	}

	std::cout << "Values larger than 6 and less than 1_000 which cannot be the surface area of a cuboid:"
              << std::endl;
	for ( uint32_t i = 3; i < half_maximum_area; ++i ) {
		if ( ohalloran_numbers[i] ) {
			std::cout << i * 2 << " ";
		}
	}
	std::cout << std::endl;
}
