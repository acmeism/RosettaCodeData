#include <algorithm>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

const char HYPHEN = '-';
const char SPACE = ' ';
const char UNDERSCORE = '_';
const std::string WHITESPACE = " \n\r\t\f\v";

std::string left_trim(const std::string& text) {
    size_t start = text.find_first_not_of(WHITESPACE);
    return ( start == std::string::npos ) ? "" : text.substr(start);
}

std::string right_trim(const std::string& text) {
    size_t end = text.find_last_not_of(WHITESPACE);
    return ( end == std::string::npos ) ? "" : text.substr(0, end + 1);
}

std::string trim(const std::string& text) {
    return left_trim(right_trim(text));
}

void prepare_for_conversion(std::string& text) {
	text = trim(text);
	std::replace(text.begin(), text.end(), SPACE, UNDERSCORE);
	std::replace(text.begin(), text.end(), HYPHEN, UNDERSCORE);
}

std::string to_snake_case(std::string& camel) {
	prepare_for_conversion(camel);
	std::string snake = "";
	bool first = true;
	for ( const char& ch : camel ) {
		if ( first ) {
			snake += ch;
			first = false;
		} else if ( ! first && ch >= 'A' && ch <= 'Z' ) {
			if ( snake[snake.length() - 1] == UNDERSCORE ) {
				snake += tolower(ch);
			} else {
				snake += UNDERSCORE;
				snake += tolower(ch);
			}
		} else {
			snake += ch;
		}
	}
	return snake;
}

std::string to_camel_case(std::string& snake) {
	prepare_for_conversion(snake);
	std::string camel = "";
	bool underscore = false;
	for ( const char& ch : snake ) {
		if ( ch == UNDERSCORE ) {
			underscore = true;
		} else if ( underscore ) {
			camel += toupper(ch);
			underscore = false;
		} else {
			camel += ch;
		}
	}
	return camel;
}

int main() {
	const std::vector<std::string> variable_names = { "snakeCase", "snake_case", "variable_10_case",
        "variable10Case", "ergo rE tHis", "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  " };

	std::cout << std::setw(48) << "=== To snake_case ===" << std::endl;
	for ( std::string text : variable_names ) {
		std::cout << std::setw(34) << text << " --> " << to_snake_case(text) << std::endl;
	}

	std::cout << std::endl;
	std::cout << std::setw(48) << "=== To camelCase ===" << std::endl;
	for ( std::string text : variable_names ) {
		std::cout << std::setw(34) <<  text << " --> " << to_camel_case(text) << std::endl;
	}
}
