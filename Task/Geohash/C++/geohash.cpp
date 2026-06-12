#include <bitset>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

const std::string GEO_BASE_32 = "0123456789bcdefghjkmnpqrstuvwxyz";

struct Range {
	double lower;
	double upper;
};

struct Location {
	double latitude;
	double longitude;

	std::string to_string() {
		const std::string sector_SN = ( latitude < 0 ) ? " S" : " N";
		const std::string sector_WE = ( longitude < 0 ) ? " W" : " E";
		return "(" + std::to_string(latitude) + sector_SN
            + ", " + std::to_string(longitude) + sector_WE + ")";
	}
};

std::string encode_geohash(const Location& location, const uint32_t& precision) {
	Range latitude_range(-90.0, 90.0);
	Range longitude_range(-180.0, 180.0);
	std::string geohash = "";
	uint32_t geohash_value = 0;
	uint32_t bit_count = 0;
	bool even = true;

	while ( geohash.length() < precision ) {
		const double value = even ? location.longitude : location.latitude;
		Range range = even ? longitude_range : latitude_range;
		const double midRange = ( range.lower + range.upper ) / 2;

		if ( value > midRange ) {
			geohash_value = ( geohash_value << 1 ) + 1;
			range = Range(midRange, range.upper);
			if ( even ) {
				longitude_range = Range(midRange, longitude_range.upper);
			} else {
				latitude_range = Range(midRange, latitude_range.upper);
			}
		} else {
			geohash_value <<= 1;
			if ( even ) {
				longitude_range = Range(longitude_range.lower, midRange);
			} else {
				latitude_range = Range(latitude_range.lower, midRange);
			}
		}

		even = ! even;
		if ( bit_count < 4 ) {
			bit_count += 1;
		} else {
			bit_count = 0;
			geohash += GEO_BASE_32[geohash_value];
			geohash_value = 0;
		}
	}
	return geohash;
}

std::string decode_geohash(const std::string& geohash) {
	Range latitude_range(-90.0, 90.0);
	Range longitude_range(-180.0, 180.0);
	bool even = true;

	for ( uint32_t i = 0; i < geohash.length(); ++i ) {
		const std::string::size_type position = GEO_BASE_32.find(geohash.substr(i, 1));
		const std::string binary = std::bitset<5>(position).to_string();

		for ( uint32_t j = 0; j < 5; ++j ) {
			const double mid_range = even ?
				  ( longitude_range.lower + longitude_range.upper ) / 2
				: ( latitude_range.lower + latitude_range.upper ) / 2;
			if ( binary[j] == '0' ) {
				if ( even ) {
					longitude_range = Range(longitude_range.lower, mid_range);
				} else {
					latitude_range = Range(latitude_range.lower, mid_range);
				}
			} else {
				if ( even ) {
					longitude_range = Range(mid_range, longitude_range.upper);
				} else {
					latitude_range = Range(mid_range, latitude_range.upper);
				}
			}
			even = ! even;
		}
	}

	const double latitude_error = std::abs(latitude_range.lower - latitude_range.upper);
	const double longitude_error = std::abs(longitude_range.lower - longitude_range.upper);
	const double max_error = std::max(latitude_error, longitude_error);
	const double mid_latitude = ( latitude_range.lower + latitude_range.upper ) / 2;
	const double mid_longitude = ( longitude_range.lower + longitude_range.upper ) / 2;
	const std::string sector_SN = ( mid_latitude < 0 ) ? " S" : " N";
	const std::string sector_WE = ( mid_longitude < 0 ) ? " W" : " E";

	std::ostringstream stream;
	stream << std::fixed << std::setprecision(15) << "(" << mid_latitude << sector_SN
		   << ", " << mid_longitude << sector_WE << ")" << " ± " << max_error;
	return stream.str();
}

int main() {
	std::vector<Location> locations = { Location(51.433718, -0.214126),
		Location(51.433718, -0.214126), Location(57.64911, 10.40744), Location(57.64911, 10.40744) };
	std::vector<uint32_t> precisions = { 2, 9, 11, 21 };

	std::vector<std::string> test_results = { };
	for ( uint64_t i = 0; i < locations.size(); ++i ) {
		test_results.emplace_back(encode_geohash(locations[i], precisions[i]));
		std::cout << "geohash for " << locations[i].to_string() << " with precision "
		    	  << std::setw(2) << precisions[i] << " => " << test_results.back() << std::endl;
	}
	std::cout << std::endl;

	for ( const std::string& test_result : test_results ) {
		std::cout << std::left << std::setw(21) << test_result
				  << " => " << decode_geohash(test_result) << std::endl;
	}
}
