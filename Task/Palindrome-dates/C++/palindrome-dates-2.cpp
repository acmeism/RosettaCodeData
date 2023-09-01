#include <algorithm>
#include <chrono>
#include <iostream>
#include <sstream>

bool is_palindrome(const std::chrono::sys_days& date) {
	std::ostringstream stream;
	stream << date;
	std::string date_string = stream.str();

	date_string.erase(std::remove(date_string.begin(), date_string.end(), '-'), date_string.end());
	std::string original = date_string;
	std::reverse(date_string.begin(), date_string.end());

	return date_string == original;
}

int main() {
	std::chrono::year_month_day date{std::chrono::year{2020}, std::chrono::month{02}, std::chrono::day{02}};
	std::chrono::sys_days current_date = std::chrono::sys_days(date);

	std::cout << "The first 15 palindrome dates after 2020-02-02 are:" << std::endl;
	int32_t count = 0;
	while ( count < 15 ) {
		current_date += std::chrono::days{1};
		if ( is_palindrome(current_date) ) {
			std::cout << current_date << std::endl;
			count++;
		}
	}
}
