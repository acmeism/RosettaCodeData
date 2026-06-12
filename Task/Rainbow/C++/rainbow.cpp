#include <cstdint>
#include <iostream>
#include <string>
#include <vector>

int main() {
	// ANSI escape code constants for foreground text colours
	const std::string RED =    "\u001B[38;2;255;0;0m";
	const std::string ORANGE = "\u001B[38;2;255;128;0m";
	const std::string YELLOW = "\u001B[38;2;255;255;0m";
	const std::string GREEN =  "\u001B[38;2;0;255;0m";
	const std::string BLUE =   "\u001B[38;2;0;0;255m";
	const std::string INDIGO = "\u001B[38;2;75;0;130m";
	const std::string VIOLET = "\u001B[38;2;128;0;255m";

	// ANSI escape code constant to reset the terminal to its default values
	const std::string RESET = "\u001B[0m";

	const std::vector<std::string> colours = { RED, ORANGE, YELLOW, GREEN, BLUE, INDIGO, VIOLET };

	const std::string rainbow = "RAINBOW";

	for ( uint32_t i = 0; i < 7; ++i ) {
		std::cout << colours[i] << rainbow[i];
	}
	std::cout << RESET << std::endl;
}
