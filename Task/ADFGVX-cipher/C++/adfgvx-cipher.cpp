#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <random>
#include <sstream>
#include <stdexcept>
#include <string>
#include <unordered_set>
#include <vector>

const std::string ADFGVX = "ADFGVX";
const std::string ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

std::random_device random;
std::mt19937 mersenne_twister(random());

std::vector<std::vector<char>> initialise_polybius_square() {
	std::vector<char> letters(ALPHABET.begin(), ALPHABET.end());
	std::shuffle(letters.begin(), letters.end(), mersenne_twister);

	std::vector<std::vector<char>> result = { 6, std::vector<char>(6, 0) };
	for ( int32_t row = 0; row < 6; ++row ) {
		for ( int32_t column = 0; column < 6; ++column ) {
			result[row][column] = letters[6 * row + column];
		}
	}
	return result;
}

// Create a key using a word from the dictionary 'unixdict.txt'
std::string create_key(const uint64_t& size) {
	if ( size < 7 || size > 12 ) {
		throw std::invalid_argument("Key should contain between 7 and 12 letters, both inclusive.");
	}

	std::vector<std::string> candidates;
	std::fstream file_stream;
	file_stream.open("../unixdict.txt");
	std::string word;
	while ( file_stream >> word ) {
		if ( word.length() == size &&
			word.length() == std::unordered_set<char>{ word.begin(), word.end() }.size() ) {
			std::transform(word.begin(), word.end(), word.begin(), [](const char& ch){ return std::toupper(ch); });
			if ( word.find_first_not_of(ALPHABET) == std::string::npos ) {
				candidates.emplace_back(word);
			}
		}
	}
	std::shuffle(candidates.begin(), candidates.end(), mersenne_twister);
	std::string key = candidates[0];
	return key;
}

std::string encrypt(const std::string& plain_text,
					const std::vector<std::vector<char>>& polybius,
					const std::string& key) {
	std::string code = "";
	for ( const char& ch : plain_text ) {
		for ( int32_t row = 0; row < 6; ++row ) {
			for ( int32_t column = 0; column < 6; ++column ) {
				if ( polybius[row][column] == ch ) {
					code += ADFGVX[row];
					code += ADFGVX[column];
				}
			}
		}
	}

	std::string encrypted = "";
	for ( const char& ch : key ) {
		for ( uint64_t i = key.find(ch); i < code.length(); i += key.length() ) {
			encrypted += code[i];
		}
		encrypted += " ";
	}
	return encrypted;
}

std::string decrypt(const std::string& encrypted_text,
					const std::vector<std::vector<char>>& polybius,
					const std::string& key) {
	const uint64_t space_count = std::count(encrypted_text.begin(), encrypted_text.end(), ' ');
	const uint64_t code_size = encrypted_text.length() - space_count;

	std::vector<std::string> blocks;
	std::stringstream stream(encrypted_text);
	std:: string word;
	while ( stream >> word ) {
	    blocks.emplace_back(word);
	}

	std::string code = "";
	for ( int32_t i = 0; code.length() < code_size; ++i ) {
		for ( const std::string& block : blocks ) {
			if ( code.length() < code_size ) {
				code += block[i];
			}
		}
	}

	std::string plain_text = "";
	for ( uint64_t i = 0; i < code_size - 1; i += 2 ) {
		int32_t row = ADFGVX.find(code[i]);
		int32_t column = ADFGVX.find(code[i + 1]);
		plain_text += polybius[row][column];
	}
	return plain_text;
}

int main() {
	const std::vector<std::vector<char>> polybius = initialise_polybius_square();
	std::cout << "The 6 x 6 Polybius square:" << std::endl;
	std::cout << " | A D F G V X" << std::endl;
	std::cout << "--------------" << std::endl;
	for ( int32_t row = 0; row < 6; ++row ) {
		std::cout << ADFGVX[row] << "|";
		for ( int32_t column = 0; column < 6; ++column ) {
			std::cout << " " << polybius[row][column];
		}
		std::cout << std::endl;
	}
	std::cout << std::endl;

	const std::string key = create_key(9);
	std::cout << "The key is " << key << std::endl << std::endl;
	const std::string plain_text = "ATTACKAT1200AM";
	std::cout << "Plain text: " << plain_text <<std::endl << std::endl;
	const std::string encrypted_text = encrypt(plain_text, polybius, key);
	std::cout << "Encrypted: " << encrypted_text << std::endl << std::endl;
	const std::string decrypted_text = decrypt(encrypted_text, polybius, key);
	std::cout << "Decrypted: " << decrypted_text << std::endl;
}
