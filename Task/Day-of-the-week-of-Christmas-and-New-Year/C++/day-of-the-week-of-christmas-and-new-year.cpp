#include <chrono>
#include <iostream>
#include <vector>

constexpr std::chrono::year_month_day GREGORIAN_CALENDAR_START = std::chrono::year_month_day(
	std::chrono::year{1582}, std::chrono::February, std::chrono::day(24));

int main() {
	const std::vector<int> years = { 1578, 1590, 1642, 1957, 2020, 2021, 2022, 2242, 2245, 2393 };

	for ( const int& year : years ) {
		std::chrono::year_month_day new_year = std::chrono::year_month_day(
			std::chrono::year{year}, std::chrono::January, std::chrono::day(01));
		std::chrono::year_month_day christmas = std::chrono::year_month_day(
			std::chrono::year{year}, std::chrono::December, std::chrono::day(25));

		if ( std::chrono::duration_cast<std::chrono::days>(
				std::chrono::sys_days(new_year) - std::chrono::sys_days(GREGORIAN_CALENDAR_START)).count() < 0  ) {
			new_year = std::chrono::sys_days(new_year) + std::chrono::days{10};
		}

		if ( std::chrono::duration_cast<std::chrono::days>(
				std::chrono::sys_days(christmas) - std::chrono::sys_days(GREGORIAN_CALENDAR_START)).count() < 0  ) {
			christmas = std::chrono::sys_days(christmas) + std::chrono::days{10};
		}

		std::cout << "In " << year << ", New Years Day is a " << std::chrono::weekday(new_year)
				  << " and Christmas Day is a " << std::chrono::weekday(christmas) << std::endl;
	}
}
