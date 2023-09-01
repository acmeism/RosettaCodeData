#include <chrono>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

const std::vector<std::string> Tzolkin = { "Imix'", "Ik'", "Ak'bal", "K'an", "Chikchan", "Kimi", "Manik'",
	"Lamat", "Muluk", "Ok", "Chuwen", "Eb", "Ben", "Hix", "Men", "K'ib'", "Kaban", "Etz'nab'", "Kawak", "Ajaw" };

const std::vector<std::string> Haab = { "Pop", "Wo'", "Sip", "Sotz'", "Sek", "Xul", "Yaxk'in", "Mol",
	"Ch'en", "Yax", "Sak'", "Keh", "Mak", "K'ank'in", "Muwan", "Pax", "K'ayab", "Kumk'u", "Wayeb'" };


int32_t positive_modulus(const int32_t& base, const int32_t& modulus) {
	const int32_t result = base % modulus;
	return ( result < 0 ) ? result + modulus : result;
}

std::chrono::sys_days create_date(const std::string& iso_date) {
	const int year = std::stoi(iso_date.substr(0, 4));
	const unsigned int month = std::stoi(iso_date.substr(5, 7));
	const unsigned int day = std::stoi(iso_date.substr(8, 10));

	std::chrono::year_month_day date{std::chrono::year{year}, std::chrono::month{month}, std::chrono::day{day}};
	return std::chrono::sys_days(date);
}

const std::chrono::sys_days CREATION_TZOLKIN = create_date("2012-12-21");
const std::chrono::sys_days ZERO_HAAB = create_date("2019-04-02");

int32_t days_per_mayan_month(const std::string& month) {
	return ( month == "Wayeb'" ) ? 5 : 20;
}

std::string tzolkin(const std::chrono::sys_days& gregorian) {
	const int32_t days_between = ( gregorian - CREATION_TZOLKIN ).count();
	int32_t remainder = positive_modulus(days_between, 13);
	remainder += ( remainder <= 9 ) ? 4 : -9;
	return std::to_string(remainder) + " " + Tzolkin[positive_modulus(days_between - 1, 20)];
}

std::string haab(const std::chrono::sys_days& gregorian) {
	const int32_t days_between = ( gregorian - ZERO_HAAB ).count();
	int32_t remainder = positive_modulus(days_between, 365);
	const std::string month = Haab[positive_modulus(remainder + 1, 20)];
	const int32_t day_of_month = remainder % 20 + 1;
	return ( day_of_month < days_per_mayan_month(month) ) ?
		std::to_string(day_of_month) + " " + month : "Chum " + month;
}

std::string long_count(const std::chrono::sys_days& gregorian) {
	int32_t days_between = ( gregorian - CREATION_TZOLKIN ).count() + 13 * 360 * 400;
	const int32_t baktun = positive_modulus(days_between, 360 * 400);
	days_between = days_between % ( 360 * 400 );
	const int32_t katun = days_between / ( 20 * 360 );
	days_between = days_between % ( 20 * 360 );
	const int32_t tun = days_between / 360;
	days_between = days_between % 360;
	const int32_t winal = days_between / 20;
	const int32_t kin = days_between % 20;

	std::string result = "";
	for ( int32_t number : { baktun, katun, tun, winal, kin } ) {
		std::string value = std::to_string(number) + ".";
		result += ( number <= 9 ) ? "0" + value : value;
	}
	return result.substr(0, result.length() - 1);
}

std::string lords_of_the_night(const std::chrono::sys_days& gregorian) {
	const int32_t days_between = ( gregorian - CREATION_TZOLKIN ).count();
	const int32_t remainder = days_between % 9;
	return "G" + std::to_string( ( remainder <= 0 ) ? remainder + 9 : remainder );
}

int main() {
	const std::vector<std::string> iso_dates = { "2004-06-19", "2012-12-18", "2012-12-21", "2019-01-19",
		"2019-03-27", "2020-02-29", "2020-03-01", "2071-05-16", "2020-02-02" };

	std::cout << "Gregorian      Long Count         Tzolk'in    Haab'         Lords of the Night" << std::endl;
	std::cout << "------------------------------------------------------------------------------" << std::endl;
	for ( const std::string& iso_date : iso_dates ) {
		const std::chrono::sys_days date = create_date(iso_date);

		std::cout << std::left << std::setw(15) << iso_date << std::setw(19) << long_count(date)
				  << std::setw(12) << tzolkin(date) << std::setw(18) << haab(date)
				  << lords_of_the_night(date) << std::endl;
	}
}
