#include <chrono>
#include <iostream>
#include <vector>

int main() {
	const std::vector<std::chrono::month> long_months = { std::chrono::January, std::chrono::March,
		std::chrono::May, std::chrono::July, std::chrono::August, std::chrono::October, std::chrono::December };

	int month_count = 0;
	int blank_years = 0;
	for ( int y = 1900; y <= 2100; ++y ) {
		bool blank_year = true;
		for ( std::chrono::month m : long_months ) {
			std::chrono::year_month_day first_of_month{std::chrono::year{y}, m, std::chrono::day{1}};
			if ( std::chrono::weekday{first_of_month} == std::chrono::Friday ) {
				std::cout << first_of_month.year() << " " << first_of_month.month() << std::endl;
				month_count++;
				blank_year = false;
			}
		}
		if ( blank_year ) {
			blank_years++;
		}
	}
	std::cout << "Found " << month_count << " months with five Fridays, Saturdays and Sundays." << std::endl;
	std::cout << "There were " << blank_years << " years with no such months." << std::endl;
}
