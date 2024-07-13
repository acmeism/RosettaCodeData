#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <iterator>
#include <sstream>
#include <string>
#include <vector>

const char DELETE = '\x7f';

// Return the number of characters required to print the given string.
uint32_t print_size(const std::string& text) {
	uint32_t size = 0;
	for ( const char& ch : text ) {
		if ( ch == ' ' ) { size += 1; }
		if ( ch == '\t' ) { size += 4; }
	}
	return size;
}

// Split the given string into a vector of strings separated by the given delimiter.
std::vector<std::string> split_string(const std::string& text, const char& delimiter) {
	std::vector<std::string> lines;
	std::istringstream stream(text);
	std::string line;
	while ( std::getline(stream, line, delimiter) ) {
	    lines.emplace_back(line);
	}
    return lines;
}

// Return a string consisting of the given string with leading spaces and tabs removed.
std::string trim_left(const std::string& text) {
    size_t start = text.find_first_not_of(" \t");
    return ( start == std::string::npos ) ? "" : text.substr(start);
}

// Return whether the string 'haystack" contains the string 'needle'.
bool contains(const std::string& haystack, const std::string& needle) {
	return haystack.find(needle) != std::string::npos;
}

// Return a string consisting of the given string repeated the given number of times.
std::string repeat(const std::string& text, const uint32_t& multiple) {
   std::string result;
   result.reserve(multiple * text.size());
   for ( uint32_t i = 0; i < multiple; ++i ) {
      result += text;
   }
   return result;
}

// Join a vector of strings into a single string separated by the given delimiter.
std::string join(const std::vector<std::string>& lines, const std::string& delimiter) {
    std::stringstream stream;
    std::copy(lines.begin(), lines.end(), std::ostream_iterator<std::string>(stream, delimiter.c_str()));
    return stream.str();
}

enum Sort { ASCENDING, DESCENDING };

// Correct the given outline if necessary and sort it at every level using the given sort.
void sorted_outline(const std::string& outline, const Sort& sort) {
    std::vector<std::string> lines = split_string(outline, '\n');
    // Remove any initial empty lines which typical occur in raw strings.
    while ( lines[0].empty() ) {
    	lines.erase(lines.begin());
    }

    std::string previous_indent = "";
    std::vector<std::string> messages = {};

    // Correct formatting errors in each line of the outline.
    for ( uint32_t i = 0; i < lines.size(); ++i ) {
    	std::string line = lines[i];
		if ( line.starts_with(" ") || line.starts_with("\t") ) {
			std::string line_trimmed = trim_left(line);
			std::string current_indent = line.substr(0, line.size() - line_trimmed.size());
			if ( previous_indent == "" ) {
				previous_indent = current_indent;
			} else {
				bool correction_needed = false;

				if ( ( contains(current_indent, "\t") && ! contains(previous_indent, "\t") ) ||
					( ! contains(current_indent, "\t") && contains(previous_indent, "\t") ) ) {
					messages.emplace_back("Corrected inconsistent whitespace use at line \"" + line + "\"");
					correction_needed = true;
				}

				if ( print_size(current_indent) % print_size(previous_indent) != 0 ) {
					messages.emplace_back("Corrected inconsistent indent width at line \"" + line + "\"");
					correction_needed = true;
				}

				if ( correction_needed ) {
					const uint32_t multiple =
                        std::round(static_cast<double>(print_size(current_indent)) / print_size(previous_indent));
					lines[i] = repeat(previous_indent, multiple) + line_trimmed;
				}
			}
		}
    }

    // Determine the level of indent for each line of the outline.
    std::vector<uint32_t> levels(lines.size(), 0);
	uint32_t level = 1;
	std::string margin = previous_indent;
	while ( std::any_of(levels.begin(), levels.end(), [](const uint32_t& i) { return i == 0; }) ) {
		for ( uint32_t i = 0; i < lines.size(); ++i ) {
			if ( levels[i] == 0 ) {
				const std::string line = lines[i];
				if ( line.starts_with(margin) && line[margin.size()] != ' ' && line[margin.size()] != '\t' ) {
					levels[i] = level;
				}
			}
		}
		margin += previous_indent;
		level += 1;
	}

	// Prepare the lines of the outline for sorting.
	std::vector<std::string> new_lines(lines.size(), "");
	new_lines[0] = lines[0];
	std::vector<std::string> nodes = {};
	for ( uint32_t i = 1; i < lines.size(); ++i ) {
		if ( levels[i] > levels[i - 1] ) {
			nodes.emplace_back(nodes.empty() ? lines[i - 1] : "\n" + lines[i - 1]);
		} else if ( levels[i] < levels[i - 1] ) {
			for ( uint32_t j = 1; j <= levels[i - 1] - levels[i]; ++j ) {
				nodes.pop_back();
			}
		}

		if ( ! nodes.empty() ) {
			new_lines[i] = join(nodes, "") + "\n" + lines[i];
		} else {
			new_lines[i] = lines[i];
		}
	}

	// Sort the lines of the outline.
	if ( sort == Sort::ASCENDING ) {
		std::sort(new_lines.begin(), new_lines.end());
	} else {
		// Pad each line of the outline on the right with 'DELETE' characters.
		const uint64_t max_size =
            std::ranges::max_element(new_lines, std::ranges::less{}, &std::string::size) -> size();
		for ( uint64_t i = 0; i < new_lines.size(); ++i ) {
			new_lines[i].insert(new_lines[i].size(), max_size - new_lines[i].size(), DELETE);
		}

		std::sort(new_lines.begin(), new_lines.end(), std::greater<std::string>());
	}

	for ( uint32_t i = 0; i < new_lines.size(); ++i ) {
		std::vector<std::string> sections = split_string(new_lines[i], '\n');
		new_lines[i] = sections.back();

		if ( sort == Sort::DESCENDING ) {
			// Remove the padding of 'DELETE' characters
			const int32_t start = new_lines[i].find_first_of(DELETE);
			if ( start > 0 ) {
				new_lines[i] = new_lines[i].substr(0, start);
			}
		}
	}

	// Display error messages
	if ( ! messages.empty() ) {
		for ( const std::string& message : messages ) {
			std::cout << message << std::endl;
		}
	}

    // Display corrected and sorted outline
	std::cout << join(new_lines, "\n") << std::endl;
}

int main() {
	std::string outline_spaces = R"(
    zeta
        beta
        gamma
            lambda
            kappa
            mu
        delta
    alpha
        theta
        iota
        epsilon)";

	std::string outline_tabs = R"(
	zeta
		beta
			gamma
			lambda
			kappa
			mu
		delta
	alpha
		theta
		iota
		epsilon)";

	// All spaces except for the line 'kappa' which contains a tab.
	std::string outline_faulty_1 = R"(
    alpha
        epsilon
            iota
        theta
    zeta
        beta
        delta
        gamma
    	    kappa
            lambda
            mu)";

	// All spaces with lines 'gamma' and 'kappa' misaligned.
	std::string outline_faulty_2 = R"(
    zeta
        beta
       gamma
            lambda
             kappa
            mu
        delta
    alpha
        theta
        iota
        epsilon)";

	std::cout << "Four space indented outline, ascending sort:" << std::endl;
	sorted_outline(outline_spaces, Sort::ASCENDING);

	std::cout << "Four space indented outline, descending sort:" << std::endl;
	sorted_outline(outline_spaces, Sort::DESCENDING);

	std::cout << "Tab indented outline, ascending sort:" << std::endl;
	sorted_outline(outline_tabs, Sort::ASCENDING);

	std::cout << "Tab space indented outline, descending sort:" << std::endl;
	sorted_outline(outline_tabs, Sort::DESCENDING);

	std::cout << "First faulty outline, ascending sort:" << std::endl;
	sorted_outline(outline_faulty_1, Sort::ASCENDING);

	std::cout << "First faulty outline, descending sort:" << std::endl;
	sorted_outline(outline_faulty_1, Sort::DESCENDING);

	std::cout << "Second faulty outline, ascending sort:" << std::endl;
	sorted_outline(outline_faulty_2, Sort::ASCENDING);

	std::cout << "Second faulty outline, descending sort:" << std::endl;
	sorted_outline(outline_faulty_2, Sort::DESCENDING);
}
