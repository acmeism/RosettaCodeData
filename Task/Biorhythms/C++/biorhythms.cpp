#include <chrono>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <numbers>
#include <sstream>
#include <string>
#include <vector>

const double tau = 2 * std::numbers::pi;
const std::vector<std::string> cycles { "PHYSICAL", "EMOTIONAL", "MENTAL" };
const std::vector<std::int32_t> cycle_lengths { 23, 28, 33 };
const std::vector<std::vector<std::string>> descriptions { { "up and rising", "peak" },
										                   { "up but falling", "transition" },
										                   { "down and falling", "valley" },
									                       { "down but rising", "transition" } };

std::string to_string(const std::chrono::sys_days& sys_date) {
	std::stringstream stream;
	stream << sys_date;
	std::string iso_date;
	stream >> iso_date;
	return iso_date;
}

std::chrono::sys_days create_date(const std::string& iso_date) {
	const int year = std::stoi(iso_date.substr(0, 4));
	const unsigned int month = std::stoi(iso_date.substr(5, 7));
	const unsigned int day = std::stoi(iso_date.substr(8, 10));

	std::chrono::year_month_day date{std::chrono::year{year}, std::chrono::month{month}, std::chrono::day{day}};
	return std::chrono::sys_days(date);
}

void biorhythms(const std::vector<std::string>& date_pair) {
	std::chrono::sys_days birth_date = create_date(date_pair[0]);
	std::chrono::sys_days target_date = create_date(date_pair[1]);
	int32_t days_between = ( target_date - birth_date ).count();
	std::cout << "Birth date " << birth_date << ", Target date " << target_date << std::endl;
	std::cout << "Days between: " << days_between << std::endl;

	for ( int32_t i = 0; i < 3; ++i ) {
		const int32_t cycle_length = cycle_lengths[i];
		const int32_t position_in_cycle = days_between % cycle_length;
		const int32_t quadrant_index = 4 * position_in_cycle / cycle_length;
		const int32_t percentage = round(100 * sin(tau * position_in_cycle / cycle_length));

		std::string description;
		if ( percentage > 95 ) {
			description = "peak";
		} else if ( percentage < -95 ) {
			description = "valley";
		} else if ( abs(percentage) < 5 ) {
			description = "critical transition";
		} else {
			const int32_t days_to_transition = ( cycle_length * ( quadrant_index + 1 ) / 4 ) - position_in_cycle;
			std::chrono::sys_days transition_date = target_date + std::chrono::days{days_to_transition};
			std::string trend = descriptions[quadrant_index][0];
			std::string next_transition = descriptions[quadrant_index][1];
			description = std::to_string(percentage) + "% (" + trend + ", next " + next_transition
				+ " " + to_string(transition_date) + ")";
		}

		std::cout << cycles[i] << " day " << position_in_cycle  << ": " << description << std::endl;
	}
	std::cout << std::endl;
}

int main() {
	const std::vector<std::vector<std::string>> date_pairs = {
		{ "1943-03-09", "1972-07-11" },
		{ "1809-01-12", "1863-11-19" },
		{ "1809-02-12", "1863-11-19" } };

	for ( const std::vector<std::string>& date_pair : date_pairs ) {
		biorhythms(date_pair);
	}
}
