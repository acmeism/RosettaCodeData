#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

class MD4 {
public:
	MD4() {
		engine_reset();
	}

	std::vector<int8_t> engine_digest(const std::string& text) {
		engine_update(string_to_byte_vector(text), 0, text.length());

		const int32_t buffer_index = static_cast<int32_t>(count % BLOCK_LENGTH);
		const int32_t padding_length = ( buffer_index < 56 ) ? 56 - buffer_index : 120 - buffer_index;

		std::vector<int8_t> tail(padding_length + 8, 0);
		tail[0] = static_cast<int8_t>(0x80);

		for ( int32_t i = 0; i < 8; ++i ) {
			tail[padding_length + i] = static_cast<int8_t>(unsigned_right_shift(count * 8, 8 * i));
		}

		engine_update(tail, 0, tail.size());

		std::vector<int8_t> result(16, 0);
		for ( int32_t i = 0; i < 4; ++i ) {
			for ( int32_t j = 0; j < 4; ++j ) {
				result[i * 4 + j] = static_cast<int8_t>(unsigned_right_shift(context[i], 8 * j));
			}
		}

		engine_reset();
		return result;
	}

private:
	void engine_update(const std::vector<int8_t>& message_bytes,
					   const int32_t& offset, const int32_t& message_length) {
		if ( offset < 0 || message_length < 0
			|| (int64_t) offset + message_length > (int64_t) message_bytes.size() ) {
			throw std::invalid_argument("Incorrect arguments for function engine_update");
		}

		int32_t buffer_index = static_cast<int32_t>(count % BLOCK_LENGTH);
		count += message_length;
		const int32_t partial_length = BLOCK_LENGTH - buffer_index;
		int32_t i = 0;

		if ( message_length >= partial_length ) {
			for ( int32_t j = 0; j < partial_length; ++j ) {
				buffer[buffer_index + j] = message_bytes[offset + j];
			}
			transform(buffer, 0);
			i = partial_length;
			while ( i + BLOCK_LENGTH - 1 < message_length ) {
				transform(message_bytes, offset + i);
				i += BLOCK_LENGTH;
			}
			buffer_index = 0;
		}

		if ( i < message_length ) {
			for ( int32_t j = 0; j < message_length - i; ++j ) {
				buffer[buffer_index + j] = message_bytes[offset + i + j];
			}
		}
	}

	void transform(const std::vector<int8_t>& buffer, int32_t offset) {
		for ( int32_t i = 0; i < 16; ++i ) {
			extra[i] = ( ( buffer[offset + 0] & 0xff )       ) |
					   ( ( buffer[offset + 1] & 0xff ) << 8  ) |
					   ( ( buffer[offset + 2] & 0xff ) << 16 ) |
					   ( ( buffer[offset + 3] & 0xff ) << 24 );
			offset += 4;
		}

		int32_t a = context[0];
		int32_t b = context[1];
		int32_t c = context[2];
		int32_t d = context[3];

		for ( const int32_t& i : { 0, 4, 8, 12 } ) {
			a = ff(a, b, c, d, extra[i + 0],  3);
			d = ff(d, a, b, c, extra[i + 1],  7);
			c = ff(c, d, a, b, extra[i + 2], 11);
			b = ff(b, c, d, a, extra[i + 3], 19);
		}

		for ( const int32_t& i : { 0, 1, 2, 3 } ) {
			a = gg(a, b, c, d, extra[i + 0],  3);
			d = gg(d, a, b, c, extra[i + 4],  5);
			c = gg(c, d, a, b, extra[i + 8],  9);
			b = gg(b, c, d, a, extra[i + 12], 13);
		}

		for ( const int32_t& i : { 0, 2, 1, 3 } ) {
			a = hh(a, b, c, d, extra[i + 0],  3);
			d = hh(d, a, b, c, extra[i + 8],  9);
			c = hh(c, d, a, b, extra[i + 4], 11);
			b = hh(b, c, d, a, extra[i + 12], 15);
		}

		context[0] += a;
		context[1] += b;
		context[2] += c;
		context[3] += d;
	}

	void engine_reset() {
		count = 0;
		context.assign(4, 0);
		context[0] = 0x67452301;
		context[1] = 0xefcdab89;
		context[2] = 0x98badcfe;
		context[3] = 0x10325476;
		extra.assign(16, 0);
		buffer.assign(BLOCK_LENGTH, 0);
	}

	std::vector<int8_t> string_to_byte_vector(const std::string& text) {
		std::vector<int8_t> bytes;
		bytes.reserve(text.size());

		std::transform(text.begin(), text.end(), std::back_inserter(bytes),
			[](char ch){ return static_cast<int8_t>(ch); });

		return bytes;
	}

	int32_t unsigned_right_shift(const int32_t& base, const int32_t& shift) {
		if ( base == 0 || shift >= 32 ) {
			return 0;
		}
		return ( base > 0 ) ? base >> shift : ( base + TWO_POWER_32 ) >> shift;
	}

	int32_t rotate(const int32_t& t, const int32_t& s) {
		return ( t << s ) | unsigned_right_shift(t, 32 - s);
	}

	int32_t ff(const int32_t& a, const int32_t& b, const int32_t& c,
			   const int32_t& d, const int32_t& x, const int32_t& s) {
		return rotate(a + ( ( b & c ) | ( ~b & d ) ) + x, s);
	}

	int32_t gg(const int32_t& a, const int32_t& b, const int32_t& c,
			   const int32_t& d, const int32_t& x, const int32_t& s) {
		return rotate(a + ( ( b & ( c | d ) ) | ( c & d ) ) + x + 0x5A827999, s);
	}

	int32_t hh(const int32_t& a, const int32_t& b, const int32_t& c,
			   const int32_t& d, const int32_t& x, const int32_t& s) {
		return rotate(a + ( b ^ c ^ d ) + x + 0x6ED9EBA1, s);
	}

	uint64_t count;
    std::vector<int32_t> context;
    std::vector<int32_t> extra;
    std::vector<int8_t> buffer;

    const int32_t BLOCK_LENGTH = 64;
    const int64_t TWO_POWER_32 = 4'294'967'296;
};

int main() {
	MD4 md4;
	std::vector<int8_t> result = md4.engine_digest("Rosetta Code");

	for ( const int8_t& bb : result ) {
		std::cout << std::hex << std::setfill('0') << std::setw(2) << ( bb & 0xff );
	}
	std::cout << std::endl;
}
