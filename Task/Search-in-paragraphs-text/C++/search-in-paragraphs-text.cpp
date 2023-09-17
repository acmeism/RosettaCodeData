#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

const std::string PARAGRAPH_SEPARATOR = "\n\n";

int main() {
	std::ifstream file;
	file.open("../Traceback.txt");
	std::stringstream stream;
	stream << file.rdbuf();
	std::string file_contents = stream.str();

	std::vector<std::string> paragraphs;
	uint64_t start;
	uint64_t end = 0;
	while ( ( start = file_contents.find_first_not_of(PARAGRAPH_SEPARATOR, end) ) != std::string::npos ) {
		end = file_contents.find(PARAGRAPH_SEPARATOR, start);
		paragraphs.emplace_back(file_contents.substr(start, end - start));
	}

	for ( const std::string& paragraph : paragraphs ) {
		if ( paragraph.find("SystemError") != std::string::npos ) {
			int32_t index = paragraph.find("Traceback (most recent call last):");
			if ( index >= 0 ) {
				std::cout << paragraph.substr(index) << std::endl;
				std::cout << "----------------" << std::endl;
			}
		}
	}
}
