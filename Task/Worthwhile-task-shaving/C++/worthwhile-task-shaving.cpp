#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

void display_time(const uint64_t& time, const std::string& interval) {
	const std::string time_string = std::to_string(time);
	const std::string plural = ( time == 1 ) ? "" : "S";
	std::cout << std::left << std::setw(12) << time_string + " " + interval + plural;
}

int main() {
	const uint32_t days_in_year = 365;
	const uint32_t minute = 60;
	const uint32_t hour = 60 * 60;
	const uint32_t day = 24 * hour;
	const uint32_t week = 7 * day;
	const uint32_t year = days_in_year * day;
	const uint32_t month = year / 12;

	const std::vector<uint32_t> yearly_usage_frequencies = {
		50 * days_in_year, 5 * days_in_year, days_in_year, days_in_year / 7, 12, 1 };

	const std::vector<uint32_t> shaved_times_in_seconds =
        { 1, 5, 30, 60, 300, 1'800, 3'600, 21'600, 86'400 };
	const std::vector<std::string> row_names = { "1 SECOND", "5 SECONDS", "30 SECONDS", "1 MINUTE",
										         "5 MINUTES", "30 MINUTES", "1 HOUR", "6 HOURS", "1 DAY" };

	std::cout << std::string(31, ' ') + "HOW OFTEN YOU DO THE TASK" + "\n\n";
	const std::vector<std::string> column_names =
	    { "SHAVED OFF   | ", "50 / DAY", "5 / DAY", "DAILY", "WEEKLY", "MONTHLY", "YEARLY" };
	for ( const std::string& column_name : column_names ) {
		std::cout << std::left << std::setw(12) << column_name;
	}
	std::cout << "\n" + std::string(87, '-') + "\n";

	const uint64_t number_of_years = 5;
	for ( uint32_t y = 0; y < 9; ++y ) {
		 std::cout << std::left << std::setw(12) << row_names[y] << " | ";
		 for ( const uint32_t& frequency : yearly_usage_frequencies ) {
			 const uint32_t time = frequency * shaved_times_in_seconds[y] * number_of_years;
			 if ( time < minute ) {
				 display_time(time, "SECOND");
			 } else if ( time < hour ) {
				 display_time(time / minute, "MINUTE");
			 } else if ( time < day ) {
				 display_time(time / hour, "HOUR");
			 } else if ( time < 14 * day ) {
				 display_time(time / day, "DAY");
			 } else if ( time < 9 * week ) {
				 display_time(time / week, "WEEK");
			 } else if ( time < year ) {
				 display_time(time / month, "MONTH");
			 } else {
				 std::cout << std::string(12, ' ');
			 }
		 }
		 std::cout << "\n";
	}
}
