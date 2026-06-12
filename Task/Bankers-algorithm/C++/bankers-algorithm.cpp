#include <cstdint>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

template <typename T>
void print_vector(const std::vector<T>& list) {
	std::cout << "[";
	for ( uint32_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] << ", ";
	}
	std::cout << list.back() << "]" << std::endl;
}

std::vector<uint32_t> split_string(const std::string& text, const char& delimiter) {
	std::vector<uint32_t> numbers;
	std::istringstream stream(text);
	std::string word;
	while ( std::getline(stream, word, delimiter) ) {
	    numbers.emplace_back(std::stoi(word));
	}
    return numbers;
}

int main () {
	// Step 1: Obtain user input
	std::string user_entry;

	uint32_t resource_count;
	std::cout << "Enter the number of resources: ";
	std::getline(std::cin, user_entry);
	std::stringstream(user_entry) >> resource_count;

	uint32_t process_count;
	std:: cout << "\n" << "Enter the number of processes: ";
	std::getline(std::cin, user_entry);
	std::stringstream(user_entry) >> process_count;

	std::cout << "\n" << "Enter the Claim Vector as a string of space separated integer: ";
	std::getline(std::cin, user_entry);
	std::vector<uint32_t> claims = split_string(user_entry, ' ');

	std::vector<std::vector<uint32_t>> allocated_resource_table;
	std::cout << "\n" << "Enter the rows of the Allocated Resource Table"
			  << " as a string of space separated integers:" << std::endl;
	for ( uint32_t row = 1; row <= process_count; ++row ) {
		std::cout << "Row " << row << ": ";
		std::getline(std::cin, user_entry);
		allocated_resource_table.emplace_back(split_string(user_entry, ' '));
	}

	std::vector<std::vector<uint32_t>> maximum_claim_table;
	std::cout << "\n" << "Enter the rows of the Maximum Claim Table"
			  << " as a string of space separated integers:" << std::endl;
	for ( uint32_t row = 1; row <= process_count; ++row ) {
		std::cout << "Row " << row << ": ";
		std::getline(std::cin, user_entry);
		maximum_claim_table.emplace_back(split_string(user_entry, ' '));
	}

	// Step 2: Initial calculations
	std::vector<uint32_t> allocated_resources(resource_count, 0);
	for ( uint32_t i = 0; i < process_count; ++i ) {
		for ( uint32_t j = 0; j < resource_count; ++j ) {
			allocated_resources[j] += allocated_resource_table[i][j];
		}
	}

	std::cout << "\n" << "Allocated resources: "; print_vector(allocated_resources);

	std::vector<uint32_t> available_resources;
	for ( uint32_t i = 0; i < resource_count; ++i ) {
		available_resources.emplace_back(claims[i] - allocated_resources[i]);
	}

	std::cout << "\n" << "Available resources: "; print_vector(available_resources);

	// Step 3: Banker's Algorithm
	std::vector<bool> running(process_count, true);
	uint32_t running_count = process_count;
	while ( running_count > 0 ) {
		bool safe_state = false;
		for ( uint32_t i = 0; i < process_count; ++i ) {
			if ( running[i] ) {
				bool process_execution = true;
				for ( uint32_t j = 0; j < resource_count; ++j ) {
					if ( maximum_claim_table[i][j] - allocated_resource_table[i][j] > available_resources[j] ) {
						process_execution = false;
						break;
					}
				}

				if ( process_execution ) {
					std::cout << "\n" << "Process " << i + 1 << " is executing." << std::endl;
					running[i] = false;
					running_count--;
					safe_state = true;
					for ( uint32_t j = 0; j < resource_count; ++j ) {
						available_resources[j] += allocated_resource_table[i][j];
					}
					break;
				}
			}
		}

		if ( ! safe_state ) {
			std::cout << "\n" << "The processes are in an unsafe state." << std::endl;
			break;
		}

		std::cout << "\n" << "The process is in a safe state." << std::endl;
		std::cout << "\n" << "Available resources: "; print_vector(available_resources);
	}
}
