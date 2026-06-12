#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <sstream>
#include <string>
#include <vector>

class Rational {
public:
	Rational(const int64_t& aNumer, const int64_t& aDenom) {
		const int64_t gcd = std::gcd(aNumer, aDenom);
		numer = aNumer / gcd;
		denom = aDenom / gcd;
	}

	Rational add(const Rational& other) const {
		return Rational(numer * other.denom + other.numer * denom, denom * other.denom);
	}

	Rational subtract(const Rational& other) const {
		return Rational(numer * other.denom - other.numer * denom, denom * other.denom);
	}

	Rational multiply(const Rational& other) const {
		return Rational(numer * other.numer, denom * other.denom);
	}

	double value() const {
		return static_cast<double>(numer) / denom;
	}

	int64_t get_numer() const {
		return numer;
	}

	int64_t get_denom() const {
		return denom;
	}

	std::string to_string() const {
		return std::to_string(numer) + " / " + std::to_string(denom);
	}

private:
	int64_t numer, denom;
};

std::vector<std::string> split_string(const std::string& text, const char& delimiter) {
	std::vector<std::string> lines;
	std::istringstream stream(text);
	std::string line;
	while ( std::getline(stream, line, delimiter) ) {
	    if ( ! line.empty() ) {
	        lines.emplace_back(line);
        }
	}
    return lines;
}

std::vector<Rational> gauss(std::vector<std::vector<Rational>> matrix) {
	const uint32_t row_count = matrix.size();
	const uint32_t col_count = matrix[0].size();

	for ( uint32_t row = 0; row < row_count; ++row ) {
		double max = std::abs(matrix[row][row].value());
		uint32_t max_index = row;
		for ( uint32_t i = row; i < row_count; ++i ) {
			if ( std::abs(matrix[i][row].value()) > max ) {
				max = std::abs(matrix[i][row].value());
				max_index = i;
			}
		}

		std::swap(matrix[row], matrix[max_index]);

		Rational inverse(matrix[row][row].get_denom(), matrix[row][row].get_numer());
		for ( uint32_t j = row + 1; j < col_count; ++j ) {
			matrix[row][j] = matrix[row][j].multiply(inverse);
		}

		for ( uint32_t j = row + 1; j < row_count; ++j ) {
			inverse = matrix[j][row];
			for ( uint32_t k = row + 1; k < col_count; ++k ) {
				matrix[j][k] = matrix[j][k].subtract(inverse.multiply(matrix[row][k]));
			}
		}
	}

	for ( uint32_t i = row_count - 1; i > 0; --i ) {
		for ( uint32_t j = 0; j < i; ++j ) {
			matrix[j][col_count - 1] =
				matrix[j][col_count - 1].subtract(matrix[j][i].multiply(matrix[i][col_count - 1]));
		}
	}

	std::vector<Rational> result;
	for ( uint32_t row = 0; row < row_count; ++row ) {
		result.emplace_back(matrix[row][col_count - 1]);
	}

	return result;
}

Rational network(const uint32_t& n, const uint32_t& k0, const uint32_t& k1, const std::string& text) {
	std::vector<std::vector<Rational>> matrix = { n, std::vector<Rational>(n + 1, Rational(0, 1)) };

	for ( const std::string& resistor : split_string(text, '|') ) {
		const std::vector<std::string> abr = split_string(resistor, ' ');
		const uint32_t a = std::stoi(abr[0]);
		const uint32_t b = std::stoi(abr[1]);
		const Rational r(1, std::stoi(abr[2]));

		matrix[a][a] = matrix[a][a].add(r);
		matrix[b][b] = matrix[b][b].add(r);

		if ( a > 0 ) {
			matrix[a][b] = matrix[a][b].subtract(r);
		}
		if ( b > 0 ) {
			matrix[b][a] = matrix[b][a].subtract(r);;
		}
	}

	matrix[k0][k0] = Rational(1, 1);
	matrix[k1][n] = Rational(1, 1);

	return gauss(matrix)[k1];
}

int main() {
	std::cout << network(7, 0, 1,
        "0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8").to_string() << std::endl;
	std::cout << network(9, 0, 8,
		"0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1").to_string() << std::endl;
	std::cout << network(16, 0, 15, "0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13 1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1").to_string() << std::endl;
	std::cout << network(4, 0, 3, "0 1 150|0 2 50|1 3 300|2 3 250").to_string() << std::endl;
}
