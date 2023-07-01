#include <iostream>
#include <iomanip>
#include <vector>
#include <bitset>

std::string to_hex(int32_t number) {
    std::stringstream stream;
    stream << std::setfill('0') << std::setw(8) << std::hex << number;
    return stream.str();
}

std::string to_binary(int32_t number) {
	std::stringstream stream;
	stream << std::bitset<16>(number);
	return stream.str();
}

int32_t twos_complement(int32_t number) {
	return ~number + 1;
}

std::string to_upper_case(std::string str) {
	for ( char& ch : str ) {
		ch = toupper(ch);
	}
	return str;
}

int main() {
	std::vector<int32_t> examples = { 0, 1, -1, 42 };

	std::cout << std::setw(9) << "decimal" << std::setw(12) << "hex"
			  << std::setw(17) << "binary" << std::setw(25) << "two's complement" << std::endl;
	std::cout << std::setw(6) << "-----------" << std::setw(12) << "--------"
			  << std::setw(20) << "----------------" << std::setw(20) << "----------------" << std::endl;

	for ( int32_t example : examples ) {
		std::cout << std::setw(6) << example << std::setw(17) << to_upper_case(to_hex(example))
				  << std::setw(20) << to_binary(example) << std::setw(13) << twos_complement(example) << std::endl;
	}
}
