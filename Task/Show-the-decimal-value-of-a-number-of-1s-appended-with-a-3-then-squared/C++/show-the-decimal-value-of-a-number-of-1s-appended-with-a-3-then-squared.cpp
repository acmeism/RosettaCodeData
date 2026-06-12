#include <cstdint>
#include <iomanip>
#include <iostream>

int main() {
	for ( uint32_t i = 0; i < 8; ++i ) {
		const uint64_t ones = std::stol(std::string(i, '1') + "3");
	    std::cout << std::setw(9) << ones << "^2 = " << ones * ones << std::endl;
	}
}
