#include <algorithm>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <string>

class ConfigData {
public:
    std::string favourite_fruit;
    bool needs_peeling;
    bool seeds_removed;
    uint32_t number_bananas;
    uint32_t number_strawberries;
};

std::string to_upper_case(const std::string& text) {
	std::string result = text;
	std::transform(result.begin(), result.end(), result.begin(),
		[](const char& ch) { return std::toupper(ch); });
	return result;
}

void read_config_file(const std::string& read_file, const ConfigData& data) {
	std::ifstream read_stream;
	read_stream.open(read_file);
	const std::string write_file = "../temp_config.txt";
	std::ofstream write_stream;
	write_stream.open(write_file);
	if ( ! read_stream.is_open() || ! write_stream.is_open() ) {
		std::cout << "Unable to open files" << std::endl;
	}

	bool done_fruit = false;
	bool done_peeling = false;
	bool done_seeds = false;
	bool done_bananas = false;
	bool done_strawberries = false;
	std::string line;
	while ( std::getline(read_stream, line) ) {
		if ( line.empty() || line[0] == '#' ) {
		   write_stream << line << "\n";
		   continue;
		}

		const std::string words = ( line.substr(0, 2) == "; " ) ?
			to_upper_case(line.substr(2)) : to_upper_case(line);

		if ( words.empty() ) { continue; }
		if ( words.substr(0, 14) == "FAVOURITEFRUIT" ) {
			if ( done_fruit ) { continue; }
			done_fruit = true;
			write_stream << "FAVOURITEFRUIT " << data.favourite_fruit << "\n";
		} else if ( words.substr(0, 12) == "NEEDSPEELING" ) {
            if ( done_peeling ) { continue; }
            done_peeling = true;
            if ( data.needs_peeling ) {
                write_stream << "NEEDSPEELING" << "\n";
            } else {
                write_stream << "; NEEDSPEELING" << "\n";
            }
        } else if ( words.substr(0, 12) == "SEEDSREMOVED" ) {
            if ( done_seeds ) { continue; }
            done_seeds = true;
            if ( data.seeds_removed ) {
                write_stream << "SEEDSREMOVED" << "\n";
            } else {
                write_stream << "; SEEDSREMOVED" << "\n";
            }
        } else if( words.substr(0, 15) == "NUMBEROFBANANAS" ) {
            if ( done_bananas ) { continue; }
            done_bananas = true;
            write_stream << "NUMBEROFBANANAS " << data.number_bananas << "\n";
        } else if( words.substr(0, 20) == "NUMBEROFSTRAWBERRIES" ) {
           if ( done_strawberries ) { continue; }
            done_strawberries = true;
            write_stream << "NUMBEROFSTRAWBERRIES " << data.number_strawberries << "\n";
        }
	}

	// Insert statements if they were absent from the original file "config.txt"
	if ( ! done_fruit ) {
		write_stream << "FAVOURITEFRUIT " + data.favourite_fruit << "\n";
	}

	if ( ! done_peeling ) {
		if ( data.needs_peeling ) {
			write_stream << "NEEDSPEELING" << "\n";
		} else {
			write_stream << "; NEEDSPEELING" << "\n";
		}
	}

	if ( ! done_seeds ) {
		if ( data.seeds_removed ) {
			write_stream << "SEEDSREMOVED" << "\n";
		} else {
			write_stream << "; SEEDSREMOVED" << "\n";
		}
	}

	if ( ! done_bananas ) {
	   write_stream << "NUMBEROFBANANAS "<< data.number_bananas << "\n";
	}

	if ( ! done_strawberries ) {
	   write_stream << "NUMBEROFSTRAWBERRIES " << data.number_strawberries << "\n";
	}

	read_stream.close();
	write_stream.close();

	std::filesystem::remove(read_file);
	std::filesystem::rename(write_file, read_file);
}

int main() {
	const std::string read_file = "../config.txt";
	ConfigData configData("banana", false, true, 1024, 62000);
	read_config_file(read_file, configData);
}
