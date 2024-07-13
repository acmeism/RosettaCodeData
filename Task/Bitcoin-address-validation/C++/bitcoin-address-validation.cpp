#include <algorithm>
#include <cstdint>
#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <vector>

#include "SHA256.cpp"
SHA256 sha256{ };

const std::string ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

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
	for ( uint32_t i = 0; i < bytes.size(); ++i ) {
		result += static_cast<char>(bytes[i]);
	}
	return result;
}

std::vector<uint32_t> decode_base_58(const std::string& text) {
	std::vector<uint32_t> result(25, 0);
	for ( const char& ch : text ) {
		std::string::size_type index = ALPHABET.find(ch);
		if ( index == static_cast<uint64_t>(-1) ) {
			throw std::invalid_argument("Invalid character found in bitcoin address");
		}
		for ( uint64_t i = result.size() - 1; i > 0; i-- ) {
			index += 58 * result[i];
			result[i] = index & 0xFF;
			index >>= 8;
		}
		if ( index != 0 ) {
			throw std::invalid_argument("Bitcoin address is too long");
		}
	}
	return result;
}

bool is_valid(const std::string& address) {
	if ( address.size() < 26 || address.size() > 35 ) {
		throw std::invalid_argument("Invalid length of bitcoin address");
	}

	std::vector<uint32_t> decoded = decode_base_58(address);
	std::vector first21(decoded.begin(), decoded.begin() + 21);

	// Convert the 'first21' into a suitable ASCII string for the first SHA256 hash
	std::string text = vector_to_ascii_string(first21);
	std::string hash_1 = sha256.message_digest(text);
	// Convert 'hashOne' into a suitable ASCII string for the second SHA256 hash
	std::vector<uint32_t> bytes_1 = hex_to_bytes(hash_1);
	std::string ascii_1 = vector_to_ascii_string(bytes_1);
	std::string hash_2 = sha256.message_digest(ascii_1);

	std::vector<uint32_t> bytes_2 = hex_to_bytes(hash_2);
	std::vector<uint32_t> checksum(bytes_2.begin(), bytes_2.begin() + 4);
	std::vector<uint32_t> last4(decoded.begin() + 21, decoded.begin() + 25);
	return checksum == last4;
}

int main() {
	const std::vector<std::string> addresses = { "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i",
											     "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62j",
											     "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9",
											     "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X",
											     "1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i" };

	for ( const std::string& address : addresses ) {
		std::cout << address << " : " << std::boolalpha << is_valid(address) << std::endl;
	}
}
