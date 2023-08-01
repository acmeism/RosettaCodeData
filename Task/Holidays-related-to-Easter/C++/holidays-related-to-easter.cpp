#include <chrono>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

std::chrono::year_month_day date_of_easter(const int32_t& year) {
	const int32_t a = year % 19;
	const int32_t b = year / 100;
	const int32_t c = year % 100;
	const int32_t d = b / 4;
	const int32_t e = b % 4;
	const int32_t f = ( b + 8 ) / 25;
	const int32_t g = ( b - f + 1 ) / 3;
	const int32_t h = ( 19 * a + b - d - g + 15 ) % 30;
	const int32_t i = c / 4;
	const int32_t k = c % 4;
	const int32_t l = ( 32 + 2 * e + 2 * i - h - k ) % 7;
	const int32_t m = ( a + 11 * h + 22 * l ) / 451;
	const int32_t n = h + l - 7 * m + 114;
	const unsigned int month = n / 31;
	const unsigned int day = ( n % 31 ) + 1;

	return { std::chrono::year{year}, std::chrono::month{month}, std::chrono::day{day} };
}

void display(const int32_t& year, const std::vector<int32_t>& holiday_offsets) {
	std::chrono::year_month_day easter = date_of_easter(year);

	std::cout << std::setw(4) << year;
	for ( const int32_t& holiday_offset : holiday_offsets ) {
		std::chrono::year_month_day date = std::chrono::sys_days(easter) + std::chrono::days{holiday_offset};
		std::cout << std::setw(7) << date.day() << std::setw(4) << date.month();
	}
	std::cout << std::endl;
}

int main() {
	const std::vector<int32_t> holiday_offsets{ 0, 39, 49, 56, 60 };

	std::cout << "Year     Easter   Ascension  Pentecost   Trinity  Corpus Christi" << std::endl;
	std::cout << " CE      Sunday   Thursday     Sunday     Sunday     Thursday   " << std::endl;
	std::cout << "----     ------   ---------  ---------   -------  --------------" << std::endl;
	for ( int32_t year = 400; year <= 2100; year += 100 ) {
		display(year, holiday_offsets);
	}
	std::cout << std::endl;

	for ( int32_t year= 2010; year <= 2020; ++year ) {
		display(year, holiday_offsets);
	}
}
