#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string_view>
#include <unordered_map>
#include <vector>

typedef std::pair<int32_t, int32_t> point;

class Bifid {
public:
	Bifid(const int32_t n, std::string_view text) {
		if ( text.length() != n * n ) {
			throw new std::invalid_argument("Incorrect length of text");
		}

		grid.resize(n);
		for ( uint64_t i = 0; i < grid.size(); i++ ) {
			grid[i].resize(n);
		}

		int32_t row = 0;
		int32_t col = 0;
		for ( const char& ch : text ) {
			grid[row][col] = ch;
			coordinates[ch] = point(row, col);
			col += 1;
			if ( col == n ) {
				col = 0;
				row += 1;
			 }
		 }

		 if ( n == 5 ) {
			 coordinates['J'] = coordinates['I'];
		 }
	}

	std::string encrypt(std::string_view text) {
		std::vector<int32_t> row_one, row_two;
		for ( const char& ch : text ) {
			point coordinate = coordinates[ch];
			row_one.push_back(coordinate.first);
			row_two.push_back(coordinate.second);
		 }

		 row_one.insert(row_one.end(), row_two.begin(), row_two.end());
		 std::string result;
		 for ( uint64_t i = 0; i < row_one.size() - 1; i += 2 ) {
			 result += grid[row_one[i]][row_one[i + 1]];
		 }
		 return result;
	}

	std::string decrypt(std::string_view text) {
		std::vector<int32_t> row;
		for ( const char& ch : text ) {
			point coordinate = coordinates[ch];
			row.push_back(coordinate.first);
			row.push_back(coordinate.second);
		}

		const int middle = row.size() / 2;
		std::vector<int32_t> row_one = { row.begin(), row.begin() + middle };
		std::vector<int32_t> row_two = { row.begin() + middle, row.end() };
		std::string result;
		for ( int32_t i = 0; i < middle; i++ ) {
			result += grid[row_one[i]][row_two[i]];
		}
		return result;
	}

	void display() const {
		for ( const std::vector<char>& row : grid ) {
			for ( const char& ch : row ) {
				std::cout << ch << " ";
			}
			std::cout << std::endl;
		}
	}
private:
	std::vector<std::vector<char>> grid;
	std::unordered_map<char, point> coordinates;
};

void runTest(Bifid& bifid, std::string_view message) {
	std::cout << "Using Polybius square:" << std::endl;
	bifid.display();
	std::cout << "Message:   " << message << std::endl;
	std::string encrypted = bifid.encrypt(message);
	std::cout << "Encrypted: " << encrypted << std::endl;
	std::string decrypted = bifid.decrypt(encrypted);
	std::cout << "Decrypted: " << decrypted << std::endl;
	std::cout << std::endl;
}

int main() {
	const std::string_view message1 = "ATTACKATDAWN";
	const std::string_view message2 = "FLEEATONCE";
	const std::string_view message3 = "THEINVASIONWILLSTARTONTHEFIRSTOFJANUARY";

	Bifid bifid1(5, "ABCDEFGHIKLMNOPQRSTUVWXYZ");
	Bifid bifid2(5, "BGWKZQPNDSIOAXEFCLUMTHYVR");

	runTest(bifid1, message1);
	runTest(bifid2, message2);
	runTest(bifid2, message1);
	runTest(bifid1, message2);

	Bifid bifid3(6, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
	runTest(bifid3, message3);
}
