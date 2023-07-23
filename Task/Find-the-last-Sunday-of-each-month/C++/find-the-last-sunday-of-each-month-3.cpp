#include <chrono>
#include <iostream>

int main() {
	std::cout << "The dates of the last Sunday in each month of 2023:" << std::endl;

	for ( unsigned int m = 1; m <= 12; ++m ) {
		std::chrono::days days_in_month = std::chrono::sys_days{std::chrono::year{2023}/m/std::chrono::last}
			- std::chrono::sys_days{std::chrono::year{2023}/m/1} + std::chrono::days{1};

		const unsigned int last_day = days_in_month / std::chrono::days{1};
		std::chrono::year_month_day ymd{std::chrono::year{2023}, std::chrono::month{m}, std::chrono::day{last_day}};

		while ( std::chrono::weekday{ymd} != std::chrono::Sunday ) {
			ymd = std::chrono::sys_days{ymd} - std::chrono::days{1};
		}

		std::cout << ymd << std::endl;
	}
}
