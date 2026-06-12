#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <optional>
#include <string>
#include <vector>

enum Faffian { Pfaffian, Hfaffian };

std::string to_string(const Faffian& faffian) {
	return ( faffian == Faffian::Pfaffian ) ? "Pfaffian" : "Hfaffain";
}

struct Signed_Perm {
	std::vector<uint32_t> permutation;
	int32_t sign;
};

template <typename T>
void print_matrix(const std::vector<std::vector<T>>& matrix) {
	for ( const std::vector<T>& row : matrix ) {
		std::cout << "|";
		for ( uint32_t i = 0; i < row.size() - 1; ++i ) {
			std::cout << std::setw(2) << row[i] << ", ";
		}
		std::cout << std::setw(2) << row[row.size() - 1] << "|" << std::endl;
	}
}

uint32_t factorial(const uint32_t& n) {
	uint32_t factorial = 1;
	for ( uint32_t i = 2; i <= n; ++i ) {
		factorial *= i;
	}
	return factorial;
}

bool is_antisymmetric(const std::vector<std::vector<int32_t>>& matrix) {
	for ( uint32_t i = 0; i < matrix.size(); ++i ) {
		if ( matrix[i][i] != 0 ) {
			return false;
		}
		for ( uint32_t j = i + 1; j < matrix.size(); ++j ) {
			if ( matrix[i][j] != -matrix[j][i] ) {
				return false;
			}
		}
	}
	return true;
}

std::vector<Signed_Perm> signed_permutations(const uint32_t& n) {
	std::vector<uint32_t> perms(n + 1);
	std::iota(perms.begin(), perms.end(), 0);
	std::vector<Signed_Perm> signed_perms(1, Signed_Perm(perms, 1));
	int32_t sign = 1;
	for ( uint32_t k = 1; k < factorial(n + 1); ++k ) {
		uint32_t i = n - 1;
		uint32_t j = n;
		while ( perms[i] > perms[i + 1] ) {
			i--;
		}
		while ( perms[j] < perms[i] ) {
			j--;
		}
		std::swap(perms[i], perms[j]);
		sign = -sign;
		i++;
		j = n;
		while ( i < j ) {
			std::swap(perms[i], perms[j]);
			sign = -sign;
			i++;
			j--;
		}
		signed_perms.emplace_back(Signed_Perm(perms, sign));
	}
	return signed_perms;
}

std::optional<int32_t> compute_faffian(const std::vector<std::vector<int32_t>>& matrix, const Faffian& faffian) {
	if ( matrix.size() % 2 != 0 ) {
		std::cout << "Matrix size must be even for " + to_string(faffian) << std::endl;
		return std::nullopt;
	}

	if ( ! is_antisymmetric(matrix) ) {
		std::cout << "The " << to_string(faffian) << " does not support non-antisymmetric matrices" << std::endl;
		return std::nullopt;
	}

	const uint32_t n = matrix.size() / 2;
	int32_t sum = 0;
	std::vector<Signed_Perm> signed_perms = signed_permutations(2 * n - 1);
	for ( Signed_Perm signed_perm : signed_perms ) {
		std::vector<uint32_t> sigma = signed_perm.permutation;
		const int32_t sign = ( faffian == Faffian::Pfaffian ) ? signed_perm.sign : 1;
		int32_t product = 1;
		for ( uint32_t i = 0; i < n; ++i ) {
			product *= matrix[sigma[2 * i]][sigma[2 * i + 1]];
		}
		sum += sign * product;
	}

	const double normalisation = 1.0 / factorial(n) / std::pow(2, n);
	return std::round(sum * normalisation);
}

int main() {
	const std::vector<std::vector<std::vector<int32_t>>> matrices = {
		{ {  0, 1 },
		  { -1, 0 } }, // Tiny 2 x 2 matrix

        { {  0,  1, -1,  2 }, // Small 4 x 4 matrix
          { -1,  0,  3, -4 },
          {  1, -3,  0,  5 },
          { -2,  4, -5,  0 } },

        { { 1,  2,  3,  4,  5,  6 }, // Symmetric 6 x 6 matrix
          { 2,  7,  8,  9, 10, 11 },
          { 3,  8, 12, 13, 14, 15 },
          { 4,  9, 13, 16, 17, 18 },
          { 5, 10, 14, 17, 19, 20 },
          { 6, 11, 15, 18, 20, 21 } },

		{ {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9 }, // Larger 10 x 10 matrix
		  { -1,  0,  8,  7,  6,  5,  4,  3,  2,  1 },
		  { -2, -8,  0,  1,  2,  3,  4,  5,  6,  7 },
		  { -3, -7, -1,  0,  6,  5,  4,  3,  2,  1 },
	      { -4, -6, -2, -6,  0,  1,  2,  3,  4,  5 },
		  { -5, -5, -3, -5, -1,  0,  4,  3,  2,  1 },
		  { -6, -4, -4, -4, -2, -4,  0,  1,  2,  3 },
		  { -7, -3, -5, -3, -3, -3, -1,  0,  2,  1 },
		  { -8, -2, -6, -2, -4, -2, -2, -2,  0,  1 },
		  { -9, -1, -7, -1, -5, -1, -3, -1, -1,  0 } }
	};

	for ( const std::vector<std::vector<int32_t>>& matrix : matrices ) {
		print_matrix(matrix);
		for ( Faffian faffian : { Pfaffian, Hfaffian } ) {
			std::optional<int32_t> result = compute_faffian(matrix, faffian);
			if ( result.has_value() ) {
				std::cout << to_string(faffian) << ": " << result.value() << std::endl;
			}
		}
		std::cout << std::endl;
	}
}
