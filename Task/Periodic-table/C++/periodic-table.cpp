#include <cstdint>
#include <iomanip>
#include <iostream>
#include <stdexcept>
#include <vector>

struct Group {
	int32_t first;
	int32_t last;
};

struct Position{
	int32_t period;
	int32_t group;
};

const std::vector<Group> GROUPS = { Group(3, 10), Group(11, 18),
	Group(19, 36), Group(37, 54), Group(55, 86), Group(87, 118) };

Position periodic_table(const int32_t& atomic_number) {
	if ( atomic_number < 1 || atomic_number > 118 ) {
		throw std::invalid_argument("Atomic number is out of range:" + atomic_number);
	}

	if ( atomic_number == 1 ) { // Hydrogen
		return Position(1, 1);
	}
	if ( atomic_number == 2 ) { // Helium
		return Position(1, 18);
	}
	if ( atomic_number >= 57 && atomic_number <= 71 ) { // Lanthanides
		return Position(8, atomic_number - 53);
	}
	if ( atomic_number >= 89 && atomic_number <= 103 ) { // Actinides
		return Position(9, atomic_number - 85);
	}

	int32_t period = 0;
	int32_t periodFirst = 0;
	int32_t periodLast = 0;
	for ( uint64_t i = 0; i < GROUPS.size() && period == 0; ++i ) {
		Group group = GROUPS[i];
		if ( atomic_number >= group.first && atomic_number <= group.last ) {
			period = i + 2;
			periodFirst = group.first;
			periodLast = group.last;
		}
	}

	if ( atomic_number < periodFirst + 2 || period == 4 || period == 5 ) {
		return Position(period, atomic_number - periodFirst + 1);
	}
	return Position(period, atomic_number - periodLast + 18);
}

int main() {
	for ( int32_t atomic_number : { 1, 2, 29, 42, 57, 58, 59, 71, 72, 89, 90, 103, 113 } ) {
		Position position = periodic_table(atomic_number);
		std::cout << "Atomic number " << std::left << std::setw(3) << atomic_number
                  << " -> " << position.period << ", " << position.group << std::endl;
	}
}
