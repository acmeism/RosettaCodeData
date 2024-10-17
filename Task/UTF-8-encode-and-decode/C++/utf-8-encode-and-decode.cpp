#include <codecvt>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

struct utf8 {
	char mask;            /* char data will be bitwise ANDed with this binary number */
	char start;           /* start index of the bytes of current char in a utf-8 encoded character */
	uint32_t begin;       /* beginning of codepoint range */
	uint32_t end;         /* end of codepoint range */
	uint32_t bits_stored; /* the number of bits from the codepoint that fit in the char */
};

const std::vector<utf8> utf8s = {
	/*    mask                          start        begin    end       bits */
	utf8{ 0b00111111, static_cast<char>(0b10000000), 0,       0,        6 },
	utf8{ 0b01111111, static_cast<char>(0b00000000), 0000,    0177,     7 },
	utf8{ 0b00011111, static_cast<char>(0b11000000), 0200,    03777,    5 },
	utf8{ 0b00001111, static_cast<char>(0b11100000), 04000,   0177777,  4 },
	utf8{ 0b00000111, static_cast<char>(0b11110000), 0200000, 04177777, 3 } };

uint32_t codepoint_size(const uint32_t& codepoint) {
	uint32_t size = 0;
	for ( const utf8& utf : utf8s ) {
		if ( ( codepoint >= utf.begin ) && ( codepoint <= utf.end ) ) {
			break;
		}
		size++;
	}
	return size;
}

uint32_t utf8_size(const char& ch) {
	uint32_t size = 0;
	for ( const utf8& utf : utf8s ) {
		if( ( ch & ~utf.mask ) == utf.start ) {
			break;
		}
		size++;
	}
	return size;
}

std::vector<char> to_utf8(const uint32_t& codepoint) {
	const uint32_t byte_count = codepoint_size(codepoint);
	std::vector<char> result{ };

	uint32_t shift = utf8s[0].bits_stored * ( byte_count - 1 );
	result.emplace_back(( codepoint >> shift & utf8s[byte_count].mask ) | utf8s[byte_count].start);
	shift -= utf8s[0].bits_stored;
	for ( uint32_t i = 1; i < byte_count; ++i ) {
		result.emplace_back(( codepoint >> shift & utf8s[0].mask ) | utf8s[0].start);
		shift -= utf8s[0].bits_stored;
	}
	return result;
}

uint32_t to_codepoint(const std::vector<char>& chars) {
	const uint32_t byte_count = utf8_size(chars[0]);
	uint32_t shift = utf8s[0].bits_stored * ( byte_count - 1 );
	uint32_t codepoint = ( chars[0] & utf8s[byte_count].mask ) << shift;

	for ( uint32_t index = 1; index < byte_count; ++index ) {
		shift -= utf8s[0].bits_stored;
		codepoint |= ( chars[index] & utf8s[0].mask ) << shift;
	}
	return codepoint;
}

int main() {
	const std::vector<uint32_t> tests = { 0x0041, 0x00f6, 0x0416, 0x20ac, 0x1d11e };

	std::cout << "Character   Unicode   UTF-8 encoding (hex)" << "\n";
	std::cout << "------------------------------------------" << "\n";

	for ( const uint32_t& test : tests ) {
		std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> convert;
		std::cout << convert.to_bytes(test) << "\t" << "    ";

		const std::vector<char> utf8 = to_utf8(test);
		const uint32_t codepoint = to_codepoint(utf8);
		std::cout << "U+" << std::setw(4) << std::setfill('0') << std::hex << codepoint << "\t";

		for ( uint32_t i = 0; i < utf8.size(); ++i ) {
			std::cout << std::setw(2) << ( utf8[i] & 0xff ) << " ";
		}
		std::cout << "\n";
	}
}
