#include <iostream>
#include <string>

void setRightAdjacent(std::string text, int32_t number) {
	std::cout << "n = " << number << ", Width = " << text.size() << ", Input: " << text << std::endl;

	std::string result = text;
	for ( uint32_t i = 0; i < result.size(); i++ ) {
		if ( text[i] == '1' ) {
			for ( uint32_t j = i + 1; j <= i + number && j < result.size(); j++ ) {
				result[j] = '1';
			}
		}
	}

	std::cout << std::string(16 + std::to_string(text.size()).size(), ' ') << "Result: " + result << "\n" << std::endl;
}

int main() {
	setRightAdjacent("1000", 2);
	setRightAdjacent("0100", 2);
	setRightAdjacent("0010", 2);
	setRightAdjacent("0000", 2);

	std::string test = "010000000000100000000010000000010000000100000010000010000100010010";
	setRightAdjacent(test, 0);
	setRightAdjacent(test, 1);
	setRightAdjacent(test, 2);
	setRightAdjacent(test, 3);
}
