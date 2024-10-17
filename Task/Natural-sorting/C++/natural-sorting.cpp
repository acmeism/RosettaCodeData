#include <algorithm>
#include <cstdint>
#include <iostream>
#include <regex>
#include <string>
#include <vector>

// Only covers ISO-8859-1 accented characters plus, for consistency, Ÿ
const std::vector<std::string> uc_accents =
	{ "ÀÁÂÃÄÅ", "Ç", "ÈÉÊË", "ÌÍÎÏ", "Ñ", "ÒÓÔÕÖØ", "ÙÚÛÜ", "ÝŸ" };
const std::vector<std::string> lc_accents =
	{ "àáâãäå", "ç", "èéêë", "ìíîï", "ñ", "òóôõöø", "ùúûü", "ýÿ" };
const std::vector<std::string> uc_unaccents = { "A", "C", "E", "I", "N", "O", "U", "Y" };
const std::vector<std::string> lc_unaccents = { "a", "c", "e", "i", "n", "o", "u", "y" };

// Only the more common ligatures
const std::vector<std::string> uc_ligatures = { "Æ", "Ĳ", "Œ" };
const std::vector<std::string> lc_ligatures = { "æ", "ĳ", "œ" };
const std::vector<std::string> uc_separates = { "AE", "IJ", "OE" };
const std::vector<std::string> lc_separates = { "ae", "ij", "oe" };

// Miscellaneous replacements
const std::vector<std::string> misc_letters = { "ß", "ſ", "ʒ" };
const std::vector<std::string> misc_replacements = { "ss", "s", "s" };

// Remove leading spaces
std::string left_trim(const std::string& text) {
    const uint64_t start = text.find_first_not_of(" \n\r\t\f\v");
    return ( start == std::string::npos ) ? "" : text.substr(start);
}

// Replace multiple spaces with a single space
std::string replace_spaces(std::string text) {
	static const std::regex regex_expr("[ ]{2,}");
	text = std::regex_replace(text, regex_expr, " ");
	return text;
}

// Replace whitespace with a single space
std::string replace_whitespace(std::string text) {
	static const std::regex regex_expr("\\s+");
	text = std::regex_replace(text, regex_expr, " ");
	return text;
}

// Display strings including whitespace as if the latter were literal characters
std::string to_display_string(std::string text) {
	const std::vector<std::string> whitespace_1 = { "\t", "\n", "\u000b", "\u000c", "\r" };
	const std::vector<std::string> whitespace_2 = { "\\t", "\\n", "\\u000b", "\\u000c", "\\r" };
	for ( uint64_t i = 0; i < whitespace_1.size(); ++i ) {
		std::regex regex_expr(whitespace_1[i]);
		text = std::regex_replace(text, regex_expr, whitespace_2[i]);
	}
	return text;
}

// Transform the string into lower case
std::string to_lower_case(std::string text) {
	std::transform(text.begin(), text.end(), text.begin(),
		[](char ch) { return std::tolower(ch); });
	return text;
}

// Pad each numeric character with leading zeros to a total length of 20
std::string zero_padding(std::string text) {
	const static std::regex digits("-?\\d+");
	const std::vector<std::string> matches{
		std::sregex_token_iterator{text.begin(), text.end(), digits, 0}, std::sregex_token_iterator{} };

	std::vector<uint64_t> indexes = { };
	for ( const std::string& match : matches ) {
		indexes.emplace_back(text.find(match));
	}

	uint32_t extra_index = 0;
	for ( uint64_t i = 0; i < matches.size(); ++i ) {
		uint64_t start_pos = text.find(matches[i], indexes[i] + extra_index);
		text = text.substr(0, start_pos) + std::string(20 - matches[i].size(), '0') + text.substr(start_pos);
		extra_index += 20 - matches[i].size();
	}
	return text;
}

std::string remove_title(std::string text) {
	return std::regex_replace(text, std::regex("^The\\s+|^An\\s+|^A\\s+"), "");
}

// Replace accented letters with their unaccented equivalent
std::string replace_accents(const std::string& text) {
	std::string result = "";
	for ( uint64_t i = 0; i < text.length(); ++i ) {
		if ( ( text[i] & 0xff ) < 128 ) {
			result += text.substr(i, 1);
			continue;
		}
		const uint64_t length = result.length();
		const std::string letter = text.substr(i, 2);

		for ( uint64_t j = 0; j < uc_accents.size(); ++j ) {
			 if ( uc_accents[j].find(letter) != std::string::npos ) {
				 result += uc_unaccents[j];
				 break;
			 }
		}

		if ( length == result.length() ) {
			for ( uint64_t j = 0; j < lc_accents.size(); ++j ) {
				if ( lc_accents[j].find(letter) != std::string::npos ) {
					result += lc_unaccents[j];
					break;
				}
			}
		}
	}
	return result;
}

// Replace ligatures with separated letters
std::string replace_ligatures(std::string text) {
	for ( uint64_t i = 0; i < uc_ligatures.size(); ++i ) {
		text = std::regex_replace(text, std::regex(uc_ligatures[i]), uc_separates[i]);
	}
	for ( uint64_t i = 0; i < lc_ligatures.size(); ++i ) {
		text = std::regex_replace(text, std::regex(lc_ligatures[i]), lc_separates[i]);
	}
	return text;
}

// Replace miscellaneous letters with their equivalent replacements
std::string replace_characters(std::string text) {
	for ( uint64_t i = 0; i < misc_letters.size(); ++i ) {
		text = std::regex_replace(text, std::regex(misc_letters[i]), misc_replacements[i]);
	}
	return text;
}

int main() {
	std::cout << "The 9 string lists, sorted 'naturally':" << "\n";
	std::vector<std::string> s1 = {
		"ignore leading spaces: 2-2",
		" ignore leading spaces: 2-1",
		"  ignore leading spaces: 2+0",
		"   ignore leading spaces: 2+1"
	};
	std::cout << "\n";;
	std::sort(s1.begin(), s1.end(),
		[](std::string lhs, std::string rhs) { return left_trim(lhs) < left_trim(rhs); });
	for ( const std::string& s : s1 ) { std::cout << s << "\n"; }

	std::vector<std::string> s2 = {
		"ignore m.a.s spaces: 2-2",
		"ignore m.a.s  spaces: 2-1",
		"ignore m.a.s   spaces: 2+0",
		"ignore m.a.s    spaces: 2+1"
	};
	std::cout << "\n";;
	std::sort(s2.begin(), s2.end(),
		[](std::string lhs, std::string rhs) { return replace_spaces(lhs) < replace_spaces(rhs); });
	for ( const std::string& s : s2 ) { std::cout << s << "\n"; }

	std::vector<std::string> s3 = {
		"Equiv. spaces: 3-3",
		"Equiv.\rspaces: 3-2",
		"Equiv.\u000cspaces: 3-1",
		"Equiv.\u000bspaces: 3+0",
		"Equiv.\nspaces: 3+1",
		"Equiv.\tspaces: 3+2"
	};
	std::cout << "\n";;
	std::sort(s3.begin(), s3.end(),
		[](std::string lhs, std::string rhs) { return replace_whitespace(lhs) < replace_whitespace(rhs); });
	for ( const std::string& s : s3 ) { std::cout << to_display_string(s) << "\n"; }

	std::vector<std::string> s4 = {
		"cASE INDEPENENT: 3-2",
		"caSE INDEPENENT: 3-1",
		"casE INDEPENENT: 3+0",
		"case INDEPENENT: 3+1"
	};
	std::cout << "\n";;
	std::sort(s4.begin(), s4.end(),
		[](std::string lhs, std::string rhs) { return to_lower_case(lhs) < to_lower_case(rhs); });
	for ( const std::string& s : s4 ) { std::cout << s << "\n"; }

	std::vector<std::string> s5 = {
		"foo100bar99baz0.txt",
		"foo100bar10baz0.txt",
		"foo1000bar99baz10.txt",
		"foo1000bar99baz9.txt"
	};
	std::cout << "\n";;
	std::sort(s5.begin(), s5.end(),
		[](std::string lhs, std::string rhs) { return zero_padding(lhs) < zero_padding(rhs); });
	for ( const std::string& s : s5 ) { std::cout << s << "\n"; }

	std::vector<std::string> s6 = {
		"The Wind in the Willows",
		"The 40th step more",
		"The 39 steps",
		"Wanda"
	};
	std::cout << "\n";;
	std::sort(s6.begin(), s6.end(),
		[](std::string lhs, std::string rhs) { return remove_title(lhs) < remove_title(rhs); });
	for ( const std::string& s : s6 ) { std::cout << s << "\n"; }

	std::vector<std::string> s7 = {
		"Equiv. ý accents: 2-2",
		"Equiv. Ý accents: 2-1",
		"Equiv. y accents: 2+0",
		"Equiv. Y accents: 2+1"
	};
	std::cout << "\n";;
	std::sort(s7.begin(), s7.end(),
		[](std::string lhs, std::string rhs) { return replace_accents(lhs) < replace_accents(rhs); });
	for ( const std::string& s : s7 ) { std::cout << s << "\n"; }

	std::vector<std::string> s8 = {
		"Ĳ ligatured ij",
	    "no ligature"
	};
	std::cout << "\n";;
	std::sort(s8.begin(), s8.end(),
		[](std::string lhs, std::string rhs) { return replace_ligatures(lhs) < replace_ligatures(rhs); });
	for ( const std::string& s : s8 ) { std::cout << s << "\n"; }

	std::vector<std::string> s9 = {
		"Start with an ʒ: 2-2",
		"Start with an ſ: 2-1",
		"Start with an ß: 2+0",
		"Start with an s: 2+1"
	};
	std::cout << "\n";;
	std::sort(s9.begin(), s9.end(),
		[](std::string lhs, std::string rhs) { return replace_characters(lhs) < replace_characters(rhs); });
	for ( const std::string& s : s9 ) { std::cout << s << "\n"; }
}
