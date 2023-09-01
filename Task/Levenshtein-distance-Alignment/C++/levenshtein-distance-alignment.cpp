#include <algorithm>
#include <cstdint>
#include <iostream>
#include <string>
#include <vector>

std::string to_lower_case(const std::string& text) {
	std::string result = text;
	std::transform(result.begin(), result.end(), result.begin(),
		[](char ch){ return std::tolower(ch); });
	return result;
}

std::vector<std::string> levenshtein_alignment(std::string a, std::string b) {
        a = to_lower_case(a);
        b = to_lower_case(b);

        std::vector<std::vector<int32_t>> costs{ a.length() + 1, std::vector<int32_t>( b.length() + 1, 0 ) };
		for ( uint64_t j = 0; j <= b.length(); ++j )
			costs[0][j] = j;
		for ( uint64_t i = 1; i <= a.length(); ++i ) {
			costs[i][0] = i;
			for ( uint64_t j = 1; j <= b.length(); ++j ) {
				costs[i][j] = std::min(std::min( costs[i - 1][j], costs[i][j - 1]) + 1,
						               a[i - 1] == b[j - 1] ? costs[i - 1][j - 1] : costs[i - 1][j - 1] + 1);
			}
		}

		std::string a_path_reversed, b_path_reversed;
		uint64_t i = a.length(), j = b.length();
		while ( i != 0 && j != 0 ) {
			if ( costs[i][j] == ( a[i - 1] == b[j - 1] ? costs[i - 1][j - 1] : costs[i - 1][j - 1] + 1 ) ) {
				a_path_reversed += a[--i];
				b_path_reversed += b[--j];
			} else if ( costs[i][j] == costs[i - 1][j] + 1 ) {
				a_path_reversed += a[--i];
				b_path_reversed += "-";
			} else if ( costs[i][j] == costs[i][j - 1] + 1 ) {
				a_path_reversed += "-";
				b_path_reversed += b[--j];
			}
		}

		std::reverse(a_path_reversed.begin(), a_path_reversed.end());
		std::reverse(b_path_reversed.begin(), b_path_reversed.end());
		return std::vector<std::string>{ a_path_reversed, b_path_reversed };
}

int main() {
	std::vector<std::string> result = levenshtein_alignment("place", "palace");
	std::cout << result[0] << std::endl;
	std::cout << result[1] << std::endl;
	std::cout << std::endl;

	result = levenshtein_alignment("rosettacode", "raisethysword");
	std::cout << result[0] << std::endl;
	std::cout << result[1] << std::endl;
}
