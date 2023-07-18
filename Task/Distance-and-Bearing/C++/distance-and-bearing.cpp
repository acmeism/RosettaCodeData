#include <cmath>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <numbers>
#include <regex>
#include <sstream>
#include <string>
#include <vector>

constexpr double RADIUS = 6'371 / 1.852; // Mean radius of the Earth in nautical miles
constexpr double RADIAN_TO_DEGREE = 180.0 / std::numbers::pi;

class airport {
public:
	airport(std::string aName, std::string aCountry, std::string aIcao, double aLatitude, double aLongitude)
	: name(aName), country(aCountry), icao(aIcao), latitude(aLatitude), longitude(aLongitude) {}

	std::string name;
	std::string country;
	std::string icao;
	double latitude;
	double longitude;
};

// Convert the given string to a double, which represents an angle,
// and then convert the angle from degrees to radians
double to_double_radians(const std::string& text) {
    std::istringstream stream(text);
    double decimal = 0.0;
    stream >> decimal;
    return decimal / RADIAN_TO_DEGREE;
}

std::string do_replace(const std::string& text, const std::string& original, const std::string& replacement) {
	return std::regex_replace(text, std::regex(original), replacement);
}

std::vector<std::string> split(const std::string& line, const char& delimiter) {
	std::stringstream stream(line);
	std::string item;
	std::vector<std::string> items;
	while ( std::getline(stream, item, delimiter) ) {
		items.push_back(std::move(item));
	}
	return items;
}

void read_file(const std::string& file_name, std::vector<airport>& airports) {
	std::ifstream airports_file(file_name);
	std::string line;
	while ( std::getline(airports_file, line) ) {
		std::vector<std::string> sections = split(line, ',');
		airport air_port(do_replace(sections[1], "\"", ""), // Remove the double quotes from the string
				         do_replace(sections[3], "\"", ""),
						 do_replace(sections[5], "\"", ""),
						 to_double_radians(sections[6]),
						 to_double_radians(sections[7]));
		airports.push_back(std::move(air_port));
	}
	airports_file.close();
}

// The given angles are in radians, and the result is in nautical miles.
double distance(double phi1, double lambda1, double phi2, double lambda2) {
	double a = pow(sin((phi2 - phi1) * 0.5), 2) + cos(phi1) * cos(phi2) * pow(sin((lambda2 - lambda1) * 0.5), 2);
	double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return RADIUS * c;
}

// The given angles are in radians, and the result is in degrees in the range [0, 360).
double bearing(double phi1, double lambda1, double phi2, double lambda2) {
	double delta = lambda2 - lambda1;
	double result = atan2(sin(delta) * cos(phi2), cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(delta));
	return std::fmod(result * RADIAN_TO_DEGREE + 360.0, 360.0);
}

int main() {
	std::vector<airport> airports;
	read_file("airports.dat", airports);

	const double plane_latitude = 51.514669 / RADIAN_TO_DEGREE;
	const double plane_longitude = 2.198581 / RADIAN_TO_DEGREE;

	std::vector<std::pair<double, uint64_t>> distances;
	for ( uint64_t i = 0; i < airports.size(); ++i ) {
		double dist = distance(plane_latitude, plane_longitude,	airports[i].latitude, airports[i].longitude);
		distances.push_back(std::make_pair(dist, i));
	}

	std::sort(distances.begin(), distances.end(),
		[](auto& left, auto& right) { return left.first < right.first; });

	std::cout << "Distance" << std::setw(9) << "Bearing" << std::setw(11) << "ICAO"
			  << std::setw(20) << "Country" << std::setw(40) << "Airport" << std::endl;
	std::cout << std::string(88, '-') << std::endl;

	for ( uint32_t i = 0; i < 20; ++i ) {
		auto[distance, index] = distances[i];
		airport air_port = airports[index];
		double bear = bearing(plane_latitude, plane_longitude, air_port.latitude, air_port.longitude);

		std::cout << std::setw(8) << std::fixed << std::setprecision(1) << distance
				  << std::setw(9) << std::setprecision(0) << std::round(bear)
				  << std::setw(11) << air_port.icao << std::setw(20) << air_port.country
				  << std::setw(40) << air_port.name << std::endl;
	}
}
