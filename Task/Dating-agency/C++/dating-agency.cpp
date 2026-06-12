#include <iostream>
#include <string>
#include <vector>

bool loves_a_sailor(const std::string& lady) {
	return lady[0] % 2 == 0;
}

bool loves_a_lady(const std::string& lady, const std::string& sailor) {
	return lady[lady.length() - 1] % 2 == sailor[sailor.length() - 1] % 2;
}

int main() {
	const std::vector<std::string> sailors = {
		"Adrian", "Caspian", "Dune", "Finn", "Fisher", "Heron", "Kai", "Ray", "Sailor", "Tao" };

	const std::vector<std::string> ladies = {
		"Ariel", "Bertha", "Blue", "Cali", "Catalina", "Gale", "Hannah", "Isla", "Marina", "Shelly" };

	for ( const std::string& lady : ladies ) {
		if ( loves_a_sailor(lady) ) {
			std::cout << "Dating service should offer a date with " << lady << std::endl;
			for ( const std::string& sailor : sailors ) {
				if ( loves_a_lady(lady, sailor) ) {
					std::cout << "    Sailor " << sailor <<  " should take an offer to date her" << std::endl;
				}
			}
		} else {
			std::cout << "Dating service should NOT offer a date with " << lady << std::endl;
		}
	}
}
