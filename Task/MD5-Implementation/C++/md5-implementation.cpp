#include <algorithm>
#include <bit>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <vector>

const uint32_t INITIAL_A = 0x67452301;
const uint32_t INITIAL_B = static_cast<uint32_t>(0xEFCDAB89L);
const uint32_t INITIAL_C = static_cast<uint32_t>(0x98BADCFEL);
const uint32_t INITIAL_D = 0x10325476;

const std::vector<uint32_t> SHIFT_AMOUNTS = { 7, 12, 17, 22, 5,  9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21 };

const std::vector<uint32_t> K = { 0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
								  0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
						 		  0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
								  0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
								  0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
								  0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
								  0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
								  0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
								  0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
								  0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
								  0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
								  0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
								  0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
								  0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
								  0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
								  0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391 };

std::string to_hex_string(const std::vector<int8_t>& bytes) {
	std::string hex_string = "";
	std::stringstream stream;
	for ( const int8_t& bb : bytes ) {
		stream << std::setfill('0') << std::setw(2) << std::hex << ( bb & 0xff );
		hex_string += stream.str();
		stream.str("");
	}
	return hex_string;
}

std::vector<int8_t> to_byte_vector(const std::string& text) {
	std::vector<int8_t> bytes;
	bytes.reserve(text.size());
	std::transform(text.begin(), text.end(),
		std::back_inserter(bytes), [](char ch){ return static_cast<int8_t>(ch); });
	return bytes;
}

std::vector<int8_t> computeMD5(const std::vector<int8_t>& message) {
	uint64_t message_length_bytes = message.size();
	uint32_t number_blocks = ( ( message_length_bytes + 8 ) >> 6 ) + 1;
	uint32_t total_length = number_blocks << 6;
	std::vector<int8_t> padding_bytes(total_length - message_length_bytes);
	padding_bytes[0] = static_cast<int8_t>(0x80);
	uint64_t message_length_bits = message_length_bytes << 3;
	for ( uint32_t i = 0; i < 8; ++i ) {
		padding_bytes[padding_bytes.size() - 8 + i] = static_cast<int8_t>(message_length_bits);
		message_length_bits >>= 8;
	}

	uint32_t a = INITIAL_A;
	uint32_t b = INITIAL_B;
	uint32_t c = INITIAL_C;
	uint32_t d = INITIAL_D;

	std::vector<uint32_t> buffer(16);
	for ( uint32_t i = 0; i < number_blocks; ++i ) {
		uint32_t index = i << 6;
		for ( uint32_t j = 0; j < 64; index++, ++j ) {
			buffer[j >> 2] = ( static_cast<uint32_t>( ( index < message_length_bytes ) ? message[index]
				: padding_bytes[index - message_length_bytes] ) << 24 ) | ( buffer[j >> 2] >> 8 );
		}

		uint32_t original_A = a;
		uint32_t original_B = b;
		uint32_t original_C = c;
		uint32_t original_D = d;

		for ( uint32_t j = 0; j < 64; ++j ) {
			uint32_t div16 = j >> 4;
			uint32_t f = 0;
			uint32_t buffer_index = j;
			switch ( div16 ) {
				case 0: f = ( b & c ) | ( ~b & d ); break;
				case 1: f = ( b & d ) | ( c & ~d ); buffer_index = ( buffer_index * 5 + 1 ) & 0x0F; break;
				case 2: f = b ^ c ^ d; buffer_index = ( buffer_index * 3 + 5 ) & 0x0F; break;
				case 3: f = c ^ ( b | ~d ); buffer_index = ( buffer_index * 7 ) & 0x0F; break;
			}
			uint32_t temp = b + std::rotl(
				a + f + buffer[buffer_index] + K[j], SHIFT_AMOUNTS[( div16 << 2 ) | ( j & 3 )]);

			a = d;
			d = c;
			c = b;
			b = temp;
		}

		a += original_A;
		b += original_B;
		c += original_C;
		d += original_D;
	}

	std::vector<int8_t> md5(16);
	uint32_t count = 0;
	for ( uint32_t i = 0; i < 4; ++i ) {
		uint32_t n = ( i == 0 ) ? a : ( ( i == 1 ) ? b : ( ( i == 2 ) ? c : d ) );
		for ( uint32_t j = 0; j < 4; ++j ) {
			md5[count++] = static_cast<int8_t>(n);
			n >>= 8;
		}
	}
	return md5;
}

int main() {
	const std::vector<std::string> tests = { "", "a", "abc", "message digest", "abcdefghijklmnopqrstuvwxyz",
		"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
		"12345678901234567890123456789012345678901234567890123456789012345678901234567890" };

	for ( const std::string& test : tests ) {
		std::cout << to_hex_string(computeMD5(to_byte_vector(test))) << " <== \"" + test + "\"" << "\n";

	}
}
