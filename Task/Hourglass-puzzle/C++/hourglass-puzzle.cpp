#include <cstdint>
#include <iostream>

int main() {
	const uint32_t time_limit = 10'000;
	const uint32_t time_required = 9;

	uint32_t four_hourglass = 0;
	uint32_t seven_hourglass = 0;

	while ( four_hourglass < time_limit ) {
		seven_hourglass = 7 - ( four_hourglass % 7 );
		if ( seven_hourglass == time_required - 4 ) {
			break;
		}
		four_hourglass += 4;
	}

	if ( four_hourglass >= time_limit ) {
		std::cout << "No solution found" << std::endl;
	} else {
		std::cout << "Turn over both hour glasses at the same time and continue flipping them each\n"
				  << "when they individually run down until the 4 hour glass has been flipped "
				  << four_hourglass / 4 << " times,\n"
				  << "when the 7 hour glass is immediately placed on its side with " << seven_hourglass
				  << " hours of sand in it.\n\n"
				  << "You can measure " << time_required << " hours by flipping the 4 hour glass once,\n"
				  << "then flipping the remaining sand in the 7 hour glass when the 4 hour glass ends."
				  << std::endl;
	}
}
