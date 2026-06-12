#include <algorithm>
#include <bitset>
#include <cstdint>
#include <filesystem>
#include <format>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

enum DumpType { HEX, XXD };

struct DumpDetails {
	DumpType type;
	uint32_t factor;
	uint32_t block_length;
	uint32_t line_length;
};

class Converter {
public:
	Converter(const std::vector<uint8_t>& aBytes, const uint32_t& aStart_Index,
			  const uint32_t& aLength, const DumpDetails& aDump_Details) {
		start_index =
            std::min(static_cast<uint32_t>(aBytes.size()), std::max(static_cast<uint32_t>(0), aStart_Index));
		length = ( aLength < 1 || aLength > aBytes.size() - start_index ) ? aBytes.size() - start_index : aLength;
		dump_details = aDump_Details;

		std::copy(aBytes.begin() + start_index, aBytes.begin() + start_index + length, std::back_inserter(bytes));
	}

	std::string to_converted_string() {
		std::string result = "";
		for ( uint32_t i = 0; i * dump_details.factor < bytes.size(); ++i ) {
			result += to_converted_row(byte_vector(i * dump_details.factor, dump_details.factor));
		}
		return result + to_hex(counter_finish);
	}

private:
	std::vector<uint8_t> byte_vector(const uint32_t& current_index, const uint32_t& current_length) {
		counter_start = current_index;
		counter_finish = std::min(static_cast<size_t>(current_index + current_length), bytes.size());

		std::vector<uint8_t> subvector(bytes.begin() + current_index, bytes.begin() + counter_finish);
		return subvector;
	}

	std::string to_converted_row(std::vector<uint8_t> row) const {
		std::string line, characters;
		for ( const uint8_t& byte : row ) {
			line += to_digit(byte);
			characters += printable_character(byte);
		}
		line = padding(insertSpace(line));
		return to_hex(counter_start) + line + "|" + characters + "|" + "\n";
	}

	std::string insertSpace(const std::string& line) const {
		std::string result = line;
		for ( uint8_t i = dump_details.block_length; i < line.size(); i += dump_details.block_length ) {
			result.insert(i++, " ");
		}
		return result;
	}

	std::string to_digit(const uint32_t& number) const {
		std::string result = "";
		switch ( dump_details.type ) {
			case DumpType::HEX : result = std::format("{:02x}", number & 0xff) + " "; break;
			case DumpType::XXD : result = std::bitset<8>(number).to_string(); break;
		};
		return result;
	}

	std::string printable_character(const uint32_t& number) const {
		return std::string(1, ( number >= 32 && number < 127 ) ? static_cast<char>(number) : '.');
	}

	std::string padding(const std::string& line) const {
		return line + std::string(dump_details.line_length - line.size(), ' ');
    }

	std::string to_hex(const uint32_t& number) const {
		return std::format("{:08x}", number) + "  ";
    }

	uint32_t counter_start = 0, counter_finish = 0;
	uint32_t start_index, length;
	std::vector<uint8_t> bytes;
	DumpDetails dump_details;
};

std::vector<uint8_t> read_file_data(const std::string& file_name) {
    std::filesystem::path input_file_path { file_name };
    const uint64_t length = std::filesystem::file_size(input_file_path);
    if ( length == 0 ) {
        return { };
    }
    std::vector<uint8_t> buffer(length);
    std::ifstream input_file(file_name, std::ios_base::binary);
    input_file.read(reinterpret_cast<char*>(buffer.data()), length);
    input_file.close();
    return buffer;
}

int main() {
	std::vector<uint8_t> bytes = read_file_data("ExampleUTF16LE.dat");

	DumpDetails hex = { DumpType::HEX, 16, 24, 50 };
	DumpDetails xxd = { DumpType::XXD, 6, 8, 55 };

	std::cout << "Hex dump of the entire file:" << std::endl;
	std::cout << Converter(bytes, 0, bytes.size(), hex).to_converted_string() << std::endl << std::endl;

	std::cout << "xxd dump of the entire file:" << std::endl;
	std::cout << Converter(bytes, 0, bytes.size(), xxd).to_converted_string() << std::endl << std::endl;

	std::cout << "Hex dump of the file from byte 20 to byte 94:" << std::endl;
	std::cout << Converter(bytes, 20, 75, hex).to_converted_string() << std::endl << std::endl;

	std::cout << "xxd dump of the file from byte 38 to byte 58:" << std::endl;
	std::cout << Converter(bytes, 38, 21, xxd).to_converted_string() << std::endl;
}
