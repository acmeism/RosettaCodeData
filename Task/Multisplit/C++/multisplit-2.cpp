#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

struct Split_data {
	std::string segment;
	int32_t index;
	std::string separator;
};

std::vector<Split_data> multi_split(const std::string& text, const std::vector<std::string>& separators) {
	std::vector<Split_data> result;
	uint64_t i = 0;
	std::string segment = "";
	while ( i < text.length() ) {
		bool found = false;
		for ( std::string separator : separators ) {
			if ( text.substr(i, separator.length()) == separator ) {
				found = true;
				result.emplace_back(segment, i, separator);
				i += separator.length();
				segment = "";
				break;
			}
		}

		if ( ! found ) {
		  segment += text[i];
		  i += 1;
		}
	}
	result.emplace_back(segment, i, "");
	return result;
}

int main() {
	for ( Split_data splits : multi_split("a!===b=!=c", { "==", "!=", "=" } ) ) {
		std::cout << std::left << std::setw(3) << "\"" + splits.segment + "\""
				  << std::setw(18) << " ( split with \"" + splits.separator + "\""
				  << " at index " << splits.index << " )" << std::endl;
	}
}
