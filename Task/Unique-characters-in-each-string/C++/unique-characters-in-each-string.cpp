#include <algorithm>
#include <cstdint>
#include <iostream>
#include <map>
#include <string>
#include <vector>

int main() {
	const std::vector<std::string> words = { "1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz" };
	std::vector<std::map<char, uint32_t>> maps;

	for ( const std::string& word : words ) {
		std::map<char, uint32_t> frequencies;
		for ( const char& ch : word ) {
			frequencies[ch]++;
		}
		std::erase_if(frequencies, [](const auto& entry) { return entry.second > 1; } );
		maps.emplace_back(frequencies);
	}

	std::vector<char> result;
	for ( const auto& [key, value] : maps[0] ) {
		if ( std::all_of(maps.begin() + 1, maps.end(),
				[key](const std::map<char, uint32_t>& mp) { return mp.contains(key); } ) ) {
			result.emplace_back(key);
		}
	}

	for ( const char& ch : result ) {
		std::cout << ch << " ";
	}
	std::cout << std::endl;
}
