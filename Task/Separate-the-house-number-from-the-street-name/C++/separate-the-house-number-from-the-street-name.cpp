#include <algorithm>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

struct Tuple {
	std::string street;
	std::string house;
};

bool is_digit(const char& ch) {
	const std::string digits = "0123456789";
	return digits.find(ch) != std::string::npos;
}

std::string right_trim(const std::string& text) {
    const size_t end = text.find_last_not_of(" \n\r\t\f\v");
    return ( end == std::string::npos ) ? "" : text.substr(0, end + 1);
}

std::vector<std::string> split_string(const std::string& text, const char& delimiter) {
	std::vector<std::string> lines;
	std::istringstream stream(text);
	std::string line;
	while ( std::getline(stream, line, delimiter) ) {
	    if ( ! line.empty() ) {
	        lines.emplace_back(line);
        }
	}
    return lines;
}

Tuple separate_street_and_house(const std::string& address) {
		std::string house = "";

	    const std::vector<std::string> fields = split_string(address, ' ');
	    const std::string last = fields[fields.size() - 1];
	    const std::string penultimate = fields[fields.size() - 2];
	    if ( is_digit(last[0]) ) {
	    	const bool a_digit = is_digit(penultimate[0]);
	    	if ( fields.size() > 2 && a_digit && ! penultimate.starts_with("194") ) {
	    		house = penultimate + " " + last;
	    	} else {
	    		house = last;
	    	}
	    } else if ( fields.size() > 2 ) {
	    	house = penultimate + " " + last;
	    }

	    std::string street = right_trim(address.substr(0, address.length() - house.length()));
	    return Tuple(street, house);
	}

int main() {
	const std::vector<std::string> addresses = {
		"Plataanstraat 5",
		"Straat 12",
		"Straat 12 II",
		"Dr. J. Straat   12",
		"Dr. J. Straat 12 a",
		"Dr. J. Straat 12-14",
		"Laan 1940 - 1945 37",
		"Plein 1940 2",
		"1213-laan 11",
		"16 april 1944 Pad 1",
		"1e Kruisweg 36",
		"Laan 1940-'45 66",
		"Laan '40-'45",
		"Langeloërduinen 3 46",
		"Marienwaerdt 2e Dreef 2",
		"Provincialeweg N205 1",
		"Rivium 2e Straat 59.",
		"Nieuwe gracht 20rd",
		"Nieuwe gracht 20rd 2",
		"Nieuwe gracht 20zw /2",
		"Nieuwe gracht 20zw/3",
		"Nieuwe gracht 20 zw/4",
		"Bahnhofstr. 4",
		"Wertstr. 10",
		"Lindenhof 1",
		"Nordesch 20",
		"Weilstr. 6",
		"Harthauer Weg 2",
		"Mainaustr. 49",
		"August-Horch-Str. 3",
		"Marktplatz 31",
		"Schmidener Weg 3",
		"Karl-Weysser-Str. 6"
	};

	std::cout << "Street                   House Number" << std::endl;
	std::cout << "---------------------    ------------" << std::endl;
	for ( const std::string& address : addresses ) {
		Tuple result = separate_street_and_house(address);
		std::cout << result.street << std::setw(33 - result.street.length())
				  << ( result.house == "" ? "(none)" : result.house ) << std::endl;
	}
}
