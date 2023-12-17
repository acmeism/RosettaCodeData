#include <iostream>
#include <string>
#include <vector>

int main() {
	// C++ uses double quotes for strings and single quotes for characters.
	std::string simple_string = "This is a simple string";
	char letter = 'A';
	std::cout << simple_string << "    " << letter << std::endl;

	// C++ can implement multiline strings.
	std::string multiline_string = R"(
			An example of multi-line string.
				Text formatting is preserved.
			This is a raw string literal, introduced in C++ 11.)";
	std::cout << multiline_string << std::endl;

	// C++'s primitive data types: bool, char, double, float, int, long, short,
    // can be used to to store data, for example,
	const int block_length = 64;
	std::cout << "block length = " << block_length << std::endl;

	// Vectors of these data types are also possible, for example,
	std::vector<double> state = { 1.0, 2.0, 3.0 };
}
