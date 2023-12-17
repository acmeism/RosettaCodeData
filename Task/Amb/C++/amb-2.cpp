#include <functional>
#include <iostream>
#include <numeric>
#include <string>
#include <vector>

std::string join(const std::string& delimiter, const std::vector<std::string>& list) {
	return list.empty() ? "" : std::accumulate(++list.begin(), list.end(), list[0],
								   [delimiter](auto& a, auto& b) { return a + delimiter + b; });
}

std::vector<std::string> amb(std::function<bool(std::string&, std::string&)> func,
		                     std::vector<std::vector<std::string>> options, std::string previous) {

	if ( options.empty() ) {
		return std::vector<std::string>();
	}

	for ( std::string& option : options.front() ) {
		if ( ! previous.empty() && ! func(previous, option) ) {
			continue;
		}

		if ( options.size() == 1 ) {
			return std::vector<std::string>(1, option);
		}

		std::vector<std::vector<std::string>> next_options(options.begin() + 1, options.end());
		std::vector<std::string> result = amb(func, next_options, option);

		if ( ! result.empty() ) {
			result.emplace(result.begin(), option);
			return result;
		}
	}

	return std::vector<std::string>();

}

std::string Amb(std::vector<std::vector<std::string>> options) {
	std::function<bool(std::string, std::string)> continues =
		[](std::string before, std::string after) { return before.back() == after.front(); };

	std::vector<std::string> amb_result = amb(continues, options, "");

	return ( amb_result.empty() ) ? "No match found" : join(" ", amb_result);
}

int main() {
	 std::vector<std::vector<std::string>> words = { { "the", "that", "a" },
			 	 	 	 	 	 	 	             { "frog", "elephant", "thing" },
										             { "walked", "treaded", "grows" },
										             { "slowly", "quickly" } };

	std::cout << Amb(words) << std::endl;
}
