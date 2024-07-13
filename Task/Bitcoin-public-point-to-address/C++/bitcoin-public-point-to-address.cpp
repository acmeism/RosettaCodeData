#include <cstdint>
#include <iostream>
#include <map>
#include <string>
#include <vector>

#include "SHA256.cpp"
#include "RIPEMD160.cpp"
SHA256 sha256{ };
RIPEMD160 ripemd160{ };

const std::string BITCOIN_SPECIAL_VALUE = "04";
const std::string BITCOIN_VERSION_NUMBER = "00";

std::map<char, uint32_t> base_map =
	{ { '0', 0 }, { '1', 1 }, { '2', 2 }, { '3', 3 }, { '4', 4 }, { '5', 5 }, { '6', 6 }, { '7', 7 },
	{ '8', 8 }, { '9', 9 }, { 'a', 10 }, { 'b', 11 }, { 'c', 12 }, { 'd', 13 }, { 'e', 14 }, { 'f', 15 },
	{ 'A', 10 }, { 'B', 11 }, { 'C', 12 }, { 'D', 13 }, { 'E', 14 }, { 'F', 15 } };

std::vector<uint32_t> hex_to_bytes(const std::string& text) {
	std::vector<uint32_t> bytes(text.size() / 2, 0);
	for ( uint64_t i = 0; i < text.size(); i += 2 ) {
		 const uint32_t first_digit = base_map[text[i]];
		 const uint32_t second_digit = base_map[text[i + 1]];
		 bytes[i / 2] = ( first_digit << 4 ) + second_digit;
	}
	return bytes;
}

std::string vector_to_ascii_string(const std::vector<uint32_t>& bytes) {
	std::string result = "";
	for ( uint64_t i = 0; i < bytes.size(); ++i ) {
		result += static_cast<char>(bytes[i]);
	}
	return result;
}

std::vector<uint32_t> compute_message_bytes(const std::string& text) {
	// Convert the hexadecimal string 'text' into a suitable ASCII string for the SHA256 hash
	std::vector<uint32_t> bytes_1 = hex_to_bytes(text);
	std::string ascii_1 = vector_to_ascii_string(bytes_1);
	std::string hexSHA256 = sha256.message_digest(ascii_1);
	// Convert the hexadecimal string 'hexSHA256' into a suitable ASCII string for the RIPEMD160 hash
	std::vector<uint32_t> bytes_2 = hex_to_bytes(hexSHA256);
	std::string ascii_2 = vector_to_ascii_string(bytes_2);
	std::string hexRIPEMD160 = BITCOIN_VERSION_NUMBER + ripemd160.message_digest(ascii_2);
	return hex_to_bytes(hexRIPEMD160);
}

std::vector<uint32_t> compute_checksum(const std::vector<uint32_t>& bytes) {
	// Convert the given byte array into a suitable ASCII string for the first SHA256 hash
	std::string ascii_1 = vector_to_ascii_string(bytes);
	std::string hex_1 = sha256.message_digest(ascii_1);
	// Convert the hexadecimal string 'hex1' into a suitable ASCII string for the second SHA256 hash
	std::vector<uint32_t> bytes_1 = hex_to_bytes(hex_1);
	std::string ascii_2 = vector_to_ascii_string(bytes_1);
	std::string hex_2 = sha256.message_digest(ascii_2);
	std::vector<uint32_t> bytes_2 = hex_to_bytes(hex_2);
	std::vector<uint32_t> result(bytes_2.begin(), bytes_2.begin() + 4);
	return result;
}

// Return the given byte array encoded into a base58 starting with most one '1'
std::string encode_base_58(std::vector<uint32_t> bytes) {
	const std::string ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
	const uint32_t ALPHABET_SIZE = ALPHABET.size();

	std::string result(34, ' ');
	for ( int64_t n = result.size() - 1; n >= 0; --n ) {
		uint32_t c = 0;
		for ( uint64_t i = 0; i < bytes.size(); ++i ) {
			c = c * 256 + bytes[i];
			bytes[i] = c / ALPHABET_SIZE;
			c %= ALPHABET_SIZE;
		}
		result[n] = ALPHABET[c];
	}

	while ( result.starts_with("11") ) {
	   result = result.substr(1);
	}
	return result;
}

//  Return the encoded address of the given coordinates.
std::string encode_address(const std::string& x, const std::string& y) {
	std::string public_point = BITCOIN_SPECIAL_VALUE + x + y;
	if ( public_point.size() != 130 ) {
		throw std::invalid_argument("Invalid public point string");
	}

	std::vector<uint32_t> message_bytes = compute_message_bytes(public_point);
	std::vector<uint32_t> checksum = compute_checksum(message_bytes);
	message_bytes.insert(message_bytes.end(), checksum.begin(), checksum.end());
	return encode_base_58(message_bytes);
}

int main() {
	std::string x = "50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352";
	std::string y = "2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6";

	std::cout << encode_address(x, y) << std::endl;
}
