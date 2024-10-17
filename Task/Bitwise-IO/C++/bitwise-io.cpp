#include <cstdint>
#include <fstream>
#include <iostream>
#include <vector>

class BitFilter {
public:
	BitFilter(const std::string& filePath) {
		writer.open(filePath, std::ios_base::binary);
		reader.open(filePath, std::ios_base::binary);
		accumulator = 0;
		bits = 0;
	}

	void write(const std::vector<char>& chars, const uint32_t& startIndex,
			   uint32_t bitCount, uint32_t bitsOmittedCount) {
		uint32_t index = startIndex + bitsOmittedCount / 8;
		bitsOmittedCount %= 8;

		while ( bitCount > 0 || bits >= 8 ) {
			while ( bits >= 8 ) {
				bits -= 8;
				writer.put(accumulator >> bits);
				accumulator &= ( 1 << bits ) - 1;
			}

			while ( bits < 8 && bitCount > 0 ) {
				accumulator = ( accumulator << 1 ) |
					( ( ( 128 >> bitsOmittedCount ) & chars[index] ) >> ( 7 - bitsOmittedCount ) );
				bitCount -= 1;
				bits += 1;
				if ( ++bitsOmittedCount == 8 ) {
					bitsOmittedCount = 0;
					index += 1;
				}
			}
		}
	}

	void read(std::vector<char>& chars, const uint32_t& startIndex,
			  uint32_t bitCount, uint32_t bitsOmittedCount) {
		uint32_t index = startIndex + bitsOmittedCount / 8;
		bitsOmittedCount %= 8;

		while ( bitCount > 0 ) {
			while ( bits > 0 && bitCount > 0 ) {
				const uint32_t mask = 128 >> bitsOmittedCount;
				if ( ( accumulator & ( 1 << ( bits - 1 ) ) ) > 0 ) {
					chars[index] = chars[index] | mask;
				} else {
					chars[index] = chars[index] & ( ~mask & 0xff );
				}

				bitCount -= 1;
				bits -= 1;
				if ( ++bitsOmittedCount >= 8 ) {
					bitsOmittedCount = 0;
					index += 1;
				}
			}

			if ( bitCount > 0 ) {
				char qq;
				reader.read((&qq), 1);
				accumulator = ( accumulator << 8 ) | qq;
				bits += 8;
			}
		}
	}

	void close_writer() {
		if ( bits != 0 ) {
			accumulator <<= 8 - bits;
			writer.put(accumulator);
		}

		writer.close();
		accumulator = 0;
		bits = 0;
	}

	void close_reader() {
		reader.close();
		accumulator = 0;
		bits = 0;
	}

private:
	uint32_t accumulator, bits;
	std::ofstream writer;
	std::ifstream reader;
};

int main() {
	BitFilter bitFilter("BitwiseIO.dat");
	std::string source = "abcde12345";
	std::vector<char> chars(source.begin(), source.end());

	// For each char in 'chars', write 7 bits omitting the most significant bit
	for ( uint32_t i = 0; i < chars.size(); ++i ) {
		bitFilter.write(chars, i, 7, 1);
	}
	bitFilter.close_writer();

	// Read 7 bits and expand to a char of 'destination' by reconstructing the most significant bit
	std::vector<char> destination(chars.size());
	for ( uint32_t i = 0; i < destination.size(); ++i ) {
		bitFilter.read(destination, i, 7, 1);
	}
	bitFilter.close_reader();

	std::string result(destination.data());
	std::cout << result << std::endl;
}
