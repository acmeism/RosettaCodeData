#include <bit>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <stdexcept>
#include <sstream>
#include <string>
#include <vector>

class RIPEMD160 {
public:
	std::string message_digest(const std::string& message) {
		std::vector<int64_t> state = { 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0 };

		std::vector<uint8_t> bytes = add_padding(message);
		for ( uint64_t i = 0; i < bytes.size() / BLOCK_LENGTH; ++i ) {
			std::vector<uint32_t> schedule(16, 0);
			for ( uint32_t j = 0; j < BLOCK_LENGTH; ++j ) {
				schedule[j / 4] |= ( bytes[i + j] ) << ( j % 4 * 8 );
			}

			int32_t a = state[0], b = state[1], c = state[2], d = state[3], e = state[4];
			int32_t aa = state[0], bb = state[1], cc = state[2], dd = state[3], ee = state[4];
			int32_t t = 0, tt = 0;

			for ( uint32_t j = 0; j < 80; ++j ) {
				uint32_t jj = j / 16;
				t = std::rotl(a + ff(jj + 1, b, c, d) + schedule[RL[j]] + KL[jj], SL[j]) + e;
				tt = std::rotl(aa + ff(5 - jj, bb, cc, dd) + schedule[RR[j]] + KR[jj], SR[j]) + ee;

				a = e; e = d; d = std::rotl(static_cast<uint32_t>(c), 10); c = b; b = t;
				aa = ee; ee = dd; dd = std::rotl(static_cast<uint32_t>(cc), 10); cc = bb; bb = tt;
			}

			t        = state[1] + c + dd;
			state[1] = state[2] + d + ee;
			state[2] = state[3] + e + aa;
			state[3] = state[4] + a + bb;
			state[4] = state[0] + b + cc;
			state[0] = t;
		}

		std::stringstream stream;
		for ( uint32_t i = 0; i < state.size() * 4; ++i ) {
			int8_t byte_value = static_cast<int8_t>(unsigned_right_shift(state[i / 4], i % 4 * 8));
			stream << std::setfill('0') << std::setw(2) << std::hex << ( byte_value & 0xff );
		}
		return stream.str();
	}

private:
	std::vector<uint8_t> add_padding(const std::string& message) {
		std::vector<uint8_t> bytes(message.begin(), message.end());
		bytes.emplace_back(static_cast<uint8_t>(0x80));

		uint32_t padding = BLOCK_LENGTH - ( bytes.size() % BLOCK_LENGTH );
		if ( padding < 8 ) {
			padding += BLOCK_LENGTH;
		}
		bytes.resize(bytes.size() + padding - 8, static_cast<uint8_t>(0x0));

		const uint64_t bit_length = 8 * message.length();
		for ( uint32_t i = 0; i < 8; ++i ) {
			bytes.emplace_back(static_cast<uint8_t>( bit_length >> ( 8 * i ) ));
		}
		return bytes;
	}

	uint32_t ff(const uint32_t& group, const uint32_t& x, const uint32_t& y, const uint32_t& z) {
		uint32_t result;
		switch ( group ) {
			case 1: result = x ^ y ^ z; break;
			case 2: result = ( x & y ) | ( ~x & z ); break;
			case 3: result = ( x | ~y ) ^ z; break;
			case 4: result = ( x & z ) | ( y & ~z ); break;
			case 5: result = x ^ ( y | ~z ); break;
			default: throw std::invalid_argument("Unexpected argument: " + group);
		};
		return result;
	}

	int32_t unsigned_right_shift(const int32_t& base, const int32_t& shift) {
		if ( shift < 0 || shift >= 32 ) {
			throw std::invalid_argument("Shift must be in range 0..31: " + shift);
		}
		if ( base == 0 ) {
			return 0;
		}
		return ( base > 0 ) ? base >> shift : static_cast<uint32_t>(base) >> shift;
	}

	const std::vector<uint32_t> SR = {  8,  9,  9, 11, 13, 15, 15,  5,  7,  7,  8, 11, 14, 14, 12,  6,
										9, 13, 15,  7, 12,  8,  9, 11,  7,  7, 12,  7,  6, 15, 13, 11,
										9,  7, 15, 11,  8,  6,  6, 14, 12, 13,  5, 14, 13, 13,  7,  5,
									   15,  5,  8, 11, 14, 14,  6, 14,  6,  9, 12,  9, 12,  5, 15,  8,
										8,  5, 12,  9, 12,  5, 14,  6,  8, 13,  6,  5, 15, 13, 11, 11 };

	const std::vector<uint32_t> SL = { 11, 14, 15, 12,  5,  8,  7,  9, 11, 13, 14, 15,  6,  7,  9,  8,
										7,  6,  8, 13, 11,  9,  7, 15,  7, 12, 15,  9, 11,  7, 13, 12,
									   11, 13,  6,  7, 14,  9, 13, 15, 14,  8, 13,  6,  5, 12,  7,  5,
									   11, 12, 14, 15, 14, 15,  9,  8,  9, 14,  5,  6,  8,  6,  5, 12,
										9, 15,  5, 11,  6,  8, 13, 12,  5, 12, 13, 14, 11,  8,  5,  6 };

	const std::vector<uint32_t> RR = {  5, 14,  7,  0,  9,  2, 11,  4, 13,  6, 15,  8,  1, 10,  3, 12,
										6, 11,  3,  7,  0, 13,  5, 10, 14, 15,  8, 12,  4,  9,  1,  2,
									   15,  5,  1,  3,  7, 14,  6,  9, 11,  8, 12,  2, 10,  0,  4, 13,
										8,  6,  4,  1,  3, 11, 15,  0,  5, 12,  2, 13,  9,  7, 10, 14,
									   12, 15, 10,  4,  1,  5,  8,  7,  6,  2, 13, 14,  0,  3,  9, 11 };

	const std::vector<uint32_t> RL = {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
										7,  4, 13,  1, 10,  6, 15,  3, 12,  0,  9,  5,  2, 14, 11,  8,
										3, 10, 14,  4,  9, 15,  8,  1,  2,  7,  0,  6, 13, 11,  5, 12,
										1,  9, 11, 10,  0,  8, 12,  4, 13,  3,  7, 15, 14,  5,  6,  2,
										4,  0,  5,  9,  7, 12,  2, 10, 14,  1,  3,  8, 11,  6, 15, 13 };

	const std::vector<uint32_t> KL = { 0x00000000, 0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xa953fd4e };
	const std::vector<uint32_t> KR = { 0x50a28be6, 0x5c4dd124, 0x6d703ef3, 0x7a6d76e9, 0x00000000 };

	const uint32_t BLOCK_LENGTH = 64;
};

int main() {
	RIPEMD160 ripemd160;
	std::cout << ripemd160.message_digest("Rosetta Code") << std::endl;
}
