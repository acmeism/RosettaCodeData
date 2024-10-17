#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

class Environment {
public:
    Environment(const uint32_t& aSequence, const uint32_t& aCount) : sequence(aSequence), count(aCount) { }

    uint32_t sequence, count;
};

const uint32_t JOBS(12);
uint32_t sequence, count, current_id;
std::vector<Environment> environments = { Environment(1, 0), Environment(2, 0),  Environment(3, 0),
	Environment(4, 0), Environment(5, 0), Environment(6, 0),  Environment(7, 0), Environment(8, 0),
	Environment(9, 0), Environment(10, 0),  Environment(11, 0), Environment(12, 0) };

void switch_to(const uint32_t& id) {
	if ( id != current_id ) {
		environments[current_id].sequence = sequence;
		environments[current_id].count = count;
		current_id = id;
	}

	sequence = environments[id].sequence;
	count = environments[id].count;
}

void hailstone() {
	std::cout << std::setw(4) << sequence;
	if ( sequence == 1 ) {
		return;
	}

	count += 1;
	sequence = ( sequence % 2 == 1 ) ? 3 * sequence + 1 : sequence / 2;
}

bool all_done() {
	for ( uint32_t job = 0; job < JOBS; ++job ) {
		switch_to(job);
		if ( sequence > 1 ) {
			return false;
		}
	}
	return true;
}

void code() {
	 while ( ! all_done() ) {
		for ( uint32_t job = 0; job < JOBS; ++job ) {
			switch_to(job);
			hailstone();
		}
		std::cout << "\n";
	}

	std::cout << "\n" << "Counts:" << "\n";
	for ( uint32_t job = 0; job < JOBS; ++job ) {
		switch_to(job);
		std::cout << std::setw(4) << count;
	}
	std::cout << "\n";
}

int main() {
	code();
}
