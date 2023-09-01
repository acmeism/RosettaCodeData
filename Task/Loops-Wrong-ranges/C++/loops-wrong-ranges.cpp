#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

struct LoopData {
	int32_t start;
	int32_t stop;
	int32_t increment;
	std::string comment;
};

void print_vector(const std::vector<int32_t>& list) {
	std::cout << "[";
	for ( uint64_t i = 0; i < list.size(); ++i ) {
		std::cout << list[i];
		if ( i < list.size() - 1 ) {
			std::cout << ", ";
		}
	}
	std::cout << "]";
}

void runTest(const LoopData& loop_data) {
	std::vector<int32_t> values{};
	for ( int32_t i = loop_data.start; i <= loop_data.stop; i += loop_data.increment ) {
		values.emplace_back(i);
		if ( values.size() >= 10 ) {
			break;
		}
	}

	std::cout << std::left << std::setw(45) << loop_data.comment; print_vector(values);
	std::cout << ( values.size() == 10 ? " (loops forever)" : "" ) << std::endl;
}

int main() {
	runTest(LoopData(-2, 2, 1,  "Normal"));
	runTest(LoopData(-2, 2, 0,  "Zero increment"));
	runTest(LoopData(-2, 2, -1, "Increments away from stop value"));
	runTest(LoopData(-2, 2, 10, "First increment is beyond stop value"));
	runTest(LoopData(2, -2, 1,  "Start more than stop: positive increment"));
	runTest(LoopData(2, 2, 1,   "Start equal stop: positive increment"));
	runTest(LoopData(2, 2, -1,  "Start equal stop: negative increment"));
	runTest(LoopData(2, 2, 0,   "Start equal stop: zero increment"));
	runTest(LoopData(0, 0, 0,   "Start equal stop equal zero: zero increment"));
}
