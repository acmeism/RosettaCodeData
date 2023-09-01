#include <cstdint>
#include <iostream>
#include <string>

uint32_t number, power;

void number_initialise() {
	number = 0;
	power = 1;
}

enum NumberType { Cullen, Woodhall };

uint32_t next_number(const NumberType& number_type) {
	number += 1;
	power <<= 1;
	switch ( number_type ) {
		case Cullen:   return number * power + 1;
		case Woodhall: return number * power - 1;
	};
	return 0;
}

void number_sequence(const uint32_t& count, const NumberType& number_type) {
	std::string type = ( number_type == Cullen ) ? "Cullen" : "Woodhall";
	std::cout << "The first " << count << " " << type << " numbers are:" << std::endl;
	number_initialise();
	for ( uint32_t index = 1; index <= count; ++index ) {
		std::cout << next_number(number_type) << " ";
	}
	std::cout << std::endl << std::endl;
}

int main() {
	number_sequence(20, Cullen);
	number_sequence(20, Woodhall);
}
