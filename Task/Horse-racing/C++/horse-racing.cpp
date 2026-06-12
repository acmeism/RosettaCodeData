#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <unordered_map>
#include <string>
#include <vector>

enum Gender { COLT, FILLY };

std::string gender_to_string(const Gender& gender) {
	if ( gender == Gender::COLT ) { return "Colt"; }
	return "Filly";
}

struct Info {
	Gender gender;
	double rating;
};

int main() {
	// Horses with their rating after the first 3 races
	std::unordered_map<std::string, Info> horses = {
		{ "A", { Gender::COLT, 100.0 } },
		{ "B", { Gender::FILLY, 100.0 - 8 - 2 * 2 } },
		{ "C", { Gender::COLT, 100.0 + 4 - 2 * 3.5 } },
		{ "D", { Gender::FILLY, 100.0 - 4 - 10 * 0.4 } },
		{ "E", { Gender::COLT, ( 100.0 - 4 - 10 * 0.4 ) + 7 - 2 * 1 } },
		{ "F", { Gender::COLT, ( 100.0 - 4 - 10 * 0.4 ) + 11 - 2 * ( 4 - 2 ) } },
		{ "G", { Gender::COLT, 100.0 - 10 + 10 * 0.2 } },
		{ "H", { Gender::COLT, ( 100.0 - 10 + 10 * 0.2 ) + 6 - 2 * 1.5 } },
		{ "I", { Gender::FILLY, ( 100.0 - 10 + 10 * 0.2 ) + 15 - 2 * 2 } },
		{ "J", { Gender::FILLY, 0.0 } }
	};

	// Adjustments to ratings for Race 4
	horses["B"].rating += 4.0;
	horses["C"].rating -= 4.0;
	horses["H"].rating += 3.0;
	horses["J"].rating += 100.0 - 3.0 + 10 * 0.2;

	// Filly's weight allowance adjustment
	for ( std::pair<std::string, Info> pair : horses ) {
		if ( pair.second.gender == Gender::FILLY ) {
			horses[pair.first] = Info(pair.second.gender, pair.second.rating + 3.0);
		}
	}

	// Sort in descending order of rating
	std::vector<std::pair<std::string, Info>> sorted_horses{ std::make_move_iterator(horses.begin()),
        													 std::make_move_iterator(horses.end()) };
	std::sort(sorted_horses.begin(), sorted_horses.end(),
		[](const auto& p1, const auto& p2) { return p1.second.rating > p2.second.rating; });

	// Display the expected result of Race 4
	std::cout << "Race 4" << std::endl << std::endl;
	std::cout << "Position  Horse  Weight  Distance  Gender" << std::endl;
	for ( uint32_t i = 0; i < sorted_horses.size(); ++i ) {
		std::pair<std::string, Info> entry = sorted_horses[i];
		const double weight = ( entry.second.gender == Gender::COLT ) ? 9.00 : 8.11;
		const double distance = ( i > 0 ) ?
			( sorted_horses[i - 1].second.rating - entry.second.rating ) * 0.5 : 0.0;
		const std::string position = ( i == 0 || distance > 0 ) ? std::to_string(i + 1) : std::to_string(i) + "=";
		std::cout << "   " << std::left << std::setw(9) << position << std::setw(6) << entry.first
				  << std::setw(9) << std::fixed << std::setprecision(2) << weight
				  << std::setw(9) << std::setprecision(1) << distance
				  << gender_to_string(entry.second.gender) << std::endl;
	}

	// Weight adjusted rating of the winning horse
	const double rating = sorted_horses[0].second.rating;

	// Expected time of the winning horse, calculated by comparison to horse A's time in Race 1
	const double time = 96 - ( rating - 100 ) / 10;
	std::cout << "\n" << "Time " << std::fixed << std::setprecision(0) << std::floor(time / 60)
		      << " minute " << std::setprecision(1) << std::fmod(time, 60) << " seconds" << std::endl;
}
