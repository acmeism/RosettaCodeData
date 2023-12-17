#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

class Address {
public:
	Address(const std::string& aName, const std::string& aStreet, const std::string& aCity,
			const std::string& aState, const std::string& aZipCode)
	: name(aName), street(aStreet), city(aCity), state(aState), zipCode(aZipCode) {}

	std::string address_record() {
		std::string record;
		record += fixed_length(name, 30);
		record += fixed_length(street, 30);
		record += fixed_length(city, 15);
		record += fixed_length(state, 5);
		record += fixed_length(zipCode, 10);
		return record;
	}

	static constexpr uint32_t RECORD_LENGTH = 90;

private:
	std::string fixed_length(const std::string& text, const uint64_t& size) {
		return ( text.length() > size ) ? text.substr(0, size) : text + std::string(size - text.length(), ' ');
	}

	std::string name, street, city, state, zipCode;
};

int main() {
	std::vector<Address> addresses = {
		Address("FSF Inc.", "51 Franklin Street", "Boston", "MA", "02110-1301"),
		Address("The White House", "1600 Pennsylvania Avenue NW", "Washington", "DC", "20500"),
		Address("National Security Council", "1700 Pennsylvania Avenue NW", "Washington", "DC", "20500")
	};

	std::fstream file("addresses.dat", std::ios::app | std::ios::in | std::ios::out);
	if ( ! file ) {
		std::cerr << "Error. Cannot open file." << std::endl;
		exit(EXIT_FAILURE);
	}

	for ( uint64_t i = 0; i < addresses.size(); ++i ) {
		file.seekp(i * Address::RECORD_LENGTH, std::ios::beg);
		file << addresses[i].address_record();
	}

	for ( uint64_t i = 0; i < addresses.size(); ++i ) {
		file.seekg(i * Address::RECORD_LENGTH, std::ios::beg);
		char ch;
		std::string address;
		while ( address.length() < Address::RECORD_LENGTH ) {
			file.get(ch);
			address += ch;
		}
		std::cout << address << std::endl;
	}

	file.close();
}
