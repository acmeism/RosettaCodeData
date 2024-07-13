#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <limits>
#include <string>
#include <vector>

const std::string filename = "Contacts.dat";

class Contact {
public:
	Contact(const std::string& aName, const std::string& aBirth_Date, const std::string& aState,
			const std::string& aRelation, const std::string& aEmail)
	: name(aName), birth_date(aBirth_Date), state(aState), relation(aRelation), email(aEmail) { }

	std::string get_relation() const {
		return relation;
	}

	std::string to_string() const {
		return name + ", " + birth_date + ", " + state + ", " + relation + ", " + email;
	}

	bool operator<(const Contact& other) const {
		return birth_date > other.birth_date;
	}

private:
	std::string name, birth_date, state, relation, email;
};

std::vector<Contact> contacts = { };

Contact parse(std::string entry) {
	std::vector<std::string> parts;
	uint64_t position = 0;
	while ( ( position = entry.find(", ") ) != std::string::npos ) {
		parts.emplace_back(entry.substr(0, position));
		entry.erase(0, position + 2);
	}
	return Contact(parts[0], parts[1], parts[2], parts[3], entry);
}

void write_file(const std::string& new_entry) {
	std::fstream database(filename, std::ios::out | std::ios::app);
	if ( database.is_open() ) {
		database << new_entry;
		database.close();
	} else {
		std::cerr << "Unable to open database '" << filename << "' for writing" << std::endl;
	}
}

// Open the file if it exists, otherwise create a new empty file.
void read_file() {
	std::fstream database(filename, std::ios::in | std::ios::app);
	if ( database.is_open() ) {
		std::string entry;
		while ( std::getline(database, entry) ) {
			contacts.emplace_back(parse(entry));
		}
		database.close();
	} else {
		std::cerr << "Unable to open database '" << filename << "' for reading" << std::endl;
	}
}

void add_new_entry() {
	std::cout << "Type the new entry, without inverted commas, in the format:" << std::endl;
	std::cout << "Name, Birth_Date, State, Relation, Email" << std::endl;
	std::string new_entry;
	std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n'); // Clear the keyboard buffer
	std::getline(std::cin, new_entry);
	Contact contact(parse(new_entry));
	contacts.emplace_back(contact);
	write_file(new_entry);
	std::cout << "The contact \"" << new_entry << "\" has been added to the database" << std::endl;
}

void show_latest_entry() {
	if ( ! contacts.empty() ) {
		std::cout << "The latest entry is: " + contacts.back().to_string() << std::endl;
	} else {
		std::cout << "There are currently no entries in the database" << std::endl;
	}
}

void show_latest_special_entry(const std::string& search) {
	int32_t index = contacts.size() - 1;
	while ( index >= 0 && contacts[index].get_relation() != search ) {
		index--;
	}

	if ( index >= 0 ) {
		std::cout << "The latest " << search << " entry is " + contacts[index].to_string() << std::endl;
	} else {
		std::cout << "There are currently no " << search << " entries" << std::endl;
	}
}

void show_latest_friend_entry() {
	show_latest_special_entry("Friend");
}

void show_latest_family_entry() {
	show_latest_special_entry("Family");
}

void list_all_entries_by_age() {
	if ( ! contacts.empty() ) {
		std::vector<Contact> copy_contacts = contacts;
		std::sort(copy_contacts.begin(), copy_contacts.end());
		for ( const Contact& contact : copy_contacts ) {
			std::cout << contact.to_string() << std::endl;
		}
	} else {
		std::cout << "There are currently no entries in the database" << std::endl;
	}
}

int main() {
	read_file();
	uint32_t choice = 0;
	while ( choice != 6 ) {
		std::cout << std::endl;
		std::cout << "            Menu            " << std::endl;
		std::cout << " 1: Add a new entry" << std::endl;
		std::cout << " 2: Show latest entry" << std::endl;
		std::cout << " 3: Show latest Friend entry" << std::endl;
		std::cout << " 4: Show latest Family entry" << std::endl;
		std::cout << " 5: List all entries by age" << std::endl;
		std::cout << " 6: Close the program" << std::endl;
		std::cout << std::endl;

		std::cin >> choice;
		switch ( choice ) {
			case 1 : add_new_entry(); break;
			case 2 : show_latest_entry(); break;
			case 3 : show_latest_friend_entry(); break;
			case 4 : show_latest_family_entry(); break;
			case 5 : list_all_entries_by_age(); break;
			case 6 : std::cout << "Program closed" << std::endl; break;
			default : std::cout << "Please enter a number in the range 1..6" << std::endl; break;
		}
	}
}
