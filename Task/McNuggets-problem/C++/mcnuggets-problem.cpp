#include <cstdint>
#include <iostream>
#include <vector>

void mcnuggets(int32_t limit) {
    std::vector<bool> mcnuggets_numbers(limit + 1, false);
    for ( int32_t small = 0; small <= limit; small += 6 ) {
        for ( int32_t medium = small; medium <= limit; medium += 9 ) {
            for ( int32_t large = medium; large <= limit; large += 20 ) {
            	mcnuggets_numbers[large] = true;
            }
        }
    }

    for ( int32_t i = limit; i >= 0; --i ) {
        if ( ! mcnuggets_numbers[i] ) {
            std::cout << "Maximum non-McNuggets number is " << i << std::endl;
            return;
        }
    }
}

int main() {
	mcnuggets(100);
}
