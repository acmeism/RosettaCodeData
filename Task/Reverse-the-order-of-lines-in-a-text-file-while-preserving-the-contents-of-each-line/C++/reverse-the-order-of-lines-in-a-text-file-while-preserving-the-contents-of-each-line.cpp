#include <algorithm>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

int main() {
	std::vector<std::string> lines;
	std::ifstream in_stream("../DiplomacyQuote.txt");
	std::string line;
	while ( std::getline(in_stream, line) ) {
		lines.emplace_back(line);
	}
	in_stream.close();

	std::reverse(lines.begin(), lines.end());

	std::ofstream out_stream("../DiplomacyQuote.txt");
	for ( const std::string& line : lines ) {
		out_stream << line + "\n";
	}
	out_stream.close();

	// Display the contents of the 'DiplomacyQuote.txt' file
	std::ifstream in_stream_2("../DiplomacyQuote.txt");
	while ( std::getline(in_stream_2, line) ) {
		std::cout << line << std::endl;
	}
	in_stream_2.close();
}
