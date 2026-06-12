#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

int main() {
	const std::vector<uint32_t> coins = { 200, 100, 50, 20, 10, 5, 2, 1 };
	uint32_t coinCount = 0;
	uint32_t remaining = 988;
	std::cout << "Minimum number of coins needed to make a value of " << remaining << " is:" << std::endl;
	for ( uint32_t i = 0; i < coins.size() && remaining > 0; ++i ) {
		const uint32_t n = remaining / coins[i];
		coinCount += n;
		std::cout << "    " << std::setw(3) << coins[i] << " x " << n << std::endl;
		remaining %= coins[i];
	}
	std::cout << "\n" << "A total of " << coinCount << " coins." << std::endl;
}
