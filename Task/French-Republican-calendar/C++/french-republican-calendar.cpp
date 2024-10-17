#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

const std::vector<std::string> MONTHS = {
	"Vendemiaire", "Brumaire", "Frimaire", "Nivose", "Pluviose", "Ventose", "Germinal",
	"Floreal", "Prairial", "Messidor", "Thermidor", "Fructidor", "Sansculottide" };

const std::vector<std::string> SANSCULOTTIDES = {
	"Fete de la vertu", "Fete du genie", "Fete du travail",
	"Fete de l'opinion", "Fete des recompenses", "Fete de la Revolution" };

const std::vector<std::string> GREGORIAN_MONTHS = {
	"January", "February", "March", "April", "May", "June", "July", "August",
	"September", "October", "November", "December" };

const std::chrono::year_month_day INTRODUCTION_DATE =
	{ std::chrono::year{1792}, std::chrono::month{9}, std::chrono::day{22} };

const std::chrono::year_month_day TERMINATION_DATE =
	{ std::chrono::year{1805}, std::chrono::month{12}, std::chrono::day{31} };

struct French_RC_Date {
	uint32_t year, month, day;
};

std::vector<std::string> split_string(const std::string& text, const char& delimiter) {
	std::vector<std::string> words;
	std::istringstream stream(text);
	std::string word;
	while ( std::getline(stream, word, delimiter) ) {
		words.emplace_back(word);
	}
	return words;
}

uint32_t index_of(const std::vector<std::string>& vec, const std::string& element) {
	auto iter = std::find(vec.begin(), vec.end(), element);
	return std::distance(vec.begin(), iter);
}

uint32_t additional_days_for_year(const uint32_t& year) {
	return ( year > 11 ) ? 3 : ( year > 7 ) ? 2 : ( year > 3 ) ? 1 : 0;
}

std::string to_french_rc_date_string(French_RC_Date french_rc_date) {
	if ( french_rc_date.month < 13 ) {
		return std::to_string(french_rc_date.day) + " " + MONTHS[french_rc_date.month - 1]
			   + " " + std::to_string(french_rc_date.year);
	}
	return SANSCULOTTIDES[french_rc_date.day - 1] + " " + std::to_string(french_rc_date.year);
}

std::string to_gregorian_date_string(std::chrono::year_month_day gregorian_date) {
	const uint32_t year = static_cast<int>(gregorian_date.year());
	const uint32_t month = static_cast<unsigned int>(gregorian_date.month());
	const uint32_t day = static_cast<unsigned int>(gregorian_date.day());
	const std::string month_string = GREGORIAN_MONTHS[month - 1];
	return std::to_string(day) + " " + month_string + " " + std::to_string(year);
}

std::chrono::year_month_day parse_gregorian_date(const std::string& gregorian_string) {
	std::vector<std::string> splits = split_string(gregorian_string, ' ');
	const uint32_t month = index_of(GREGORIAN_MONTHS, splits[1]) + 1;
	return std::chrono::year_month_day{std::chrono::year{std::stoi(splits[2])},
		std::chrono::month{month}, std::chrono::day{static_cast<unsigned int>(std::stoi(splits[0]))}};
}

French_RC_Date parse_french_rc_date(const std::string& french_rc_date) {
	std::vector<std::string> splits = split_string(french_rc_date, ' ');
	if ( splits.size() == 3 ) {
		const uint32_t year = std::stoi(splits[2]);
		const uint32_t month = index_of(MONTHS, splits[1]) + 1;
		const uint32_t day = std::stoi(splits[0]);
		return French_RC_Date(year, month, day);
	}

	std::string year_string = splits[splits.size() - 1];
	const uint32_t year = std::stoi(year_string);
	std::string sansculottides_day = french_rc_date.substr(0, french_rc_date.size() - year_string.size() - 1);
	const uint32_t day = index_of(SANSCULOTTIDES, sansculottides_day) + 1;
	return French_RC_Date(year, 13, day);
}

French_RC_Date to_french_rc_date(const std::chrono::year_month_day& gregorian_date) {
	const int32_t days_before =
		( std::chrono::sys_days(TERMINATION_DATE) - std::chrono::sys_days(gregorian_date) ).count();
	const int32_t days_after =
		( std::chrono::sys_days(gregorian_date) - std::chrono::sys_days(INTRODUCTION_DATE) ).count();
	if ( days_after < 0 || days_before < 0 ) {
		throw std::invalid_argument("French Republican Calendar date out of range.");
	}

	uint32_t year = ( days_after + 366 ) / 365;
	uint32_t days = ( days_after + 366 ) % 365 - additional_days_for_year(year);
	if ( days == 0 ) {
		year -= 1;
		days += 366;
	}

	if ( days < 361 ) {
		return French_RC_Date(year, days / 30 + 1, days % 30);
	}
	return French_RC_Date(year, 13, days - 360);
}

std::chrono::year_month_day to_gregorian_date(French_RC_Date french_rc_date) {
	const uint32_t days = ( french_rc_date.year - 1 ) * 365 + additional_days_for_year(french_rc_date.year)
		+ ( french_rc_date.month - 1 ) * 30 + french_rc_date.day - 1;
	return std::chrono::sys_days(INTRODUCTION_DATE) + std::chrono::days(days);
}

int main() {
	std::vector<std::string> gregorian_strings = {
		"22 September 1792", "20 May 1795", "15 July 1799", "23 September 1803", "31 December 1805" };

	std::vector<std::string> french_rc_strings = { };
	for ( const std::string& gregorian_string : gregorian_strings ) {
		std::chrono::year_month_day gregorian_date = parse_gregorian_date(gregorian_string);
		French_RC_Date french_rc_date = to_french_rc_date(gregorian_date);
		const std::string french_rc_date_string = to_french_rc_date_string(french_rc_date);
		french_rc_strings.emplace_back(french_rc_date_string);
		std::cout << gregorian_string << " => " << french_rc_date_string << "\n";
	}
	std::cout << "\n";

	for ( const std::string& french_rc_string : french_rc_strings ) {
		French_RC_Date french_rc_date = parse_french_rc_date(french_rc_string);
		std::chrono::year_month_day gregorian_date = to_gregorian_date(french_rc_date);
		const std::string gregorian_date_string = to_gregorian_date_string(gregorian_date);
		std::cout << french_rc_string << " => " << gregorian_date_string << "\n";
	}
}
