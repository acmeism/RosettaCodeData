#include <cstdint>
#include <iostream>
#include <regex>
#include <string>
#include <vector>

const std::string WHITESPACE = " \n\r\t\f\v";

std::string trim(const std::string& text) {
	const size_t start = text.find_first_not_of(WHITESPACE);
	const size_t end = text.find_last_not_of(WHITESPACE);
	return ( start == std::string::npos ) ? "" : text.substr(start, end - start + 1);
}

std::string escape_HTML(const std::string& text) {
	std::string result = std::regex_replace(text, std::regex("&"), "&amp;");
	result = std::regex_replace(result, std::regex("<"), "&lt;");
	return std::regex_replace(result, std::regex(">"), "&gt;");
}

std::vector<std::string> split_paragraphs(const std::string& text) {
	    std::vector<std::string> paragraphs{ };
	    std::string temp = "";

	    for ( const char& ch : text ) {
	        if ( ch == '\n' ) {
	        	if ( ! temp.empty() ) {
	                paragraphs.emplace_back(temp);
	                temp = "";
	        	}
	        } else {
	            temp += ch;
	        }
	    }

	    if ( ! temp.empty() ) {
	        paragraphs.emplace_back(temp);
	    }
	    return paragraphs;
	}

int main() {
	std::string sample_text = R"(
			Sample Text
		This is an example of converting plain text to HTML which demonstrates extracting a title and escaping certain characters within bulleted and numbered lists.
		* This is a bulleted list with a less than sign (<)
		* And this is its second line with a greater than sign (>)
		A 'normal' paragraph between the lists.
		1. This is a numbered list with an ampersand (&)
		2. "Second line" in double quotes
		3. 'Third line' in single quotes
		That's all folks.
	)";

	bool bulleted_list = false;
	bool numbered_list = false;
	std::vector<std::string> paragraphs = split_paragraphs(escape_HTML(sample_text));
	const std::string title = ( paragraphs[0].find_first_not_of(WHITESPACE) > 0 ) ?
		trim(paragraphs[0]) : "Untitled";

	std::cout << "<html>" << std::endl;
	std::cout << "<head><title>" << title << "</title></head>" << std::endl;
	std::cout << "<body>" << std::endl;

	for ( uint32_t i = 1; i < paragraphs.size(); ++i ) {
		const std::string paragraph = trim(paragraphs[i]);

		if ( paragraph[0] == '*' ) {
			if ( ! bulleted_list ) {
				bulleted_list = true;
				std::cout << "<ul>" << std::endl;
			}
			std::cout << "  <li>" << trim(paragraph.substr(1)) << "</li>" << std::endl;
		} else if ( bulleted_list ) {
			bulleted_list = false;
			std::cout << "</ul>" << std::endl;
		}

		if ( paragraph[0] >= '0' && paragraph[0] <= '9' && paragraph[1] == '.' ) {
		    if ( ! numbered_list ) {
				numbered_list = true;
				std::cout << "<ol>" << std::endl;
		    }
		    std::cout << "  <li>" << trim(paragraph.substr(2)) << "</li>" << std::endl;
		} else if ( numbered_list ) {
			numbered_list = false;
			std::cout << "</ol>" << std::endl;
		}

		if ( ! bulleted_list && ! numbered_list ) {
			std::cout << "<p>" << trim(paragraph) << "</p>" << std::endl;
		}
	}

	if ( bulleted_list ) {
		std::cout << "</ul>" << std::endl;
	}
	if ( numbered_list ) {
		std::cout << "</ol>" << std::endl;
	}
	std::cout << "</body>" << std::endl;
	std::cout << "</html>" << std::endl;
}
