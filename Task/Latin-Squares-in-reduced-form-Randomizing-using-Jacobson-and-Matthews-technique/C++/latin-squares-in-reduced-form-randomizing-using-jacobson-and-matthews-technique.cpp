#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>
#include <random>
#include <vector>

std::random_device random;
std::mt19937 generator(random());

template <typename T>
void print_one_based_vector(const std::vector<T>& list) {
	std::cout << "[";
	for ( uint32_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] + 1 << ", ";
	}
	std::cout << list.back() + 1 << "]";
}

template <typename T>
void print_2D_vector(const std::vector<std::vector<T>>& lists) {
	std::cout << "[";
	for ( uint32_t i = 0; i < lists.size() - 1; ++i ) {
		print_one_based_vector(lists[i]); std::cout << ", ";
	}
	print_one_based_vector(lists.back()); std::cout << "]";
}

std::vector<std::vector<std::vector<int32_t>>> create_cube(const std::vector<std::vector<int32_t>>& matrix,
														   const uint32_t& size) {
	std::vector<std::vector<std::vector<int32_t>>> cube =
		{ size, std::vector<std::vector<int32_t>>(size, std::vector<int32_t>(size, 0)) };
	for ( uint32_t i = 0; i < size; ++i ) {
		for ( uint32_t j = 0; j < size; ++j ) {
			const int32_t k = ( matrix.empty() ) ? ( i + j ) % size : matrix[i][j] - 1;
			cube[i][j][k] = 1;
		}
	}
	return cube;
}

void shuffle_cube(std::vector<std::vector<std::vector<int32_t>>>& cube) {
	bool proper = true;

	std::uniform_int_distribution<int32_t> distribution(0, cube.size() - 1);
	uint32_t rx, ry, rz;
	do {
		rx = distribution(generator);
		ry = distribution(generator);
		rz = distribution(generator);
	} while ( cube[rx][ry][rz] != 0 );

	while ( true ) {
		uint32_t ox = 0, oy = 0, oz = 0;

		while ( cube[ox][ry][rz] != 1 ) {
			ox++;
		}
		while ( cube[rx][oy][rz] != 1 ) {
			oy++;
		}
		while ( cube[rx][ry][oz] != 1 ) {
			oz++;
		}

		std::uniform_int_distribution<int32_t> distribution(0, 1);
		if ( ! proper ) {
			if ( distribution(generator) == 0 ) {
				ox++;
				while ( cube[ox][ry][rz] != 1 ) {
					ox++;
				}
			}
			if ( distribution(generator) == 0 ) {
				oy++;
				while ( cube[rx][oy][rz] != 1 ) {
					oy++;
				}
			}
			if ( distribution(generator) == 0 ) {
				oz++;
				while ( cube[rx][ry][oz] != 1 ) {
					oz++;
				}
			}
		}

		cube[rx][ry][rz]++;
		cube[rx][oy][oz]++;
		cube[ox][ry][oz]++;
		cube[ox][oy][rz]++;

		cube[rx][ry][oz]--;
		cube[rx][oy][rz]--;
		cube[ox][ry][rz]--;
		cube[ox][oy][oz]--;

		if ( cube[ox][oy][oz] < 0 ) {
			rx = ox; ry = oy; rz = oz;
			proper = false;
		} else {
			break;
		}
	}
}

std::vector<std::vector<int32_t>> to_matrix(const std::vector<std::vector<std::vector<int32_t>>>& cube) {
	std::vector<std::vector<int32_t>> matrix = { cube.size(), std::vector<int32_t>(cube.size(), 0) };
	for ( uint32_t i = 0; i < cube.size(); ++i ) {
		for ( uint32_t j = 0; j < cube.size(); ++j ) {
			for ( uint32_t k = 0; k < cube.size(); ++k ) {
				if ( cube[i][j][k] != 0 ) {
					matrix[i][j] = k;
					break;
				}
			}
		}
	}
	return matrix;
}

void reduce(std::vector<std::vector<int32_t>>& matrix) {
	for ( uint32_t j = 0; j < matrix.size() - 1; ++j ) {
		if ( matrix[0][j] != static_cast<int32_t>(j) ) {
			for ( uint32_t k = j + 1; k < matrix.size(); ++k ) {
				if ( matrix[0][k] == static_cast<int32_t>(j) ) {
					for ( uint32_t i = 0; i < matrix.size(); ++i ) {
						std::swap(matrix[i][j], matrix[i][k]);
					}
					break;
				}
			}
		}
	}

	for ( uint32_t i = 1; i < matrix.size() - 1; ++i ) {
		if ( matrix[i][0] != static_cast<int32_t>(i) ) {
			for ( uint32_t k = i + 1; k < matrix.size(); ++k ) {
				if ( matrix[k][0] == static_cast<int32_t>(i) ) {
					for ( uint32_t j = 0; j < matrix.size(); ++j ) {
						std::swap(matrix[i][j], matrix[k][j]);
					}
					break;
				}
			}
		}
	}
}

int main() {
	std::cout << "PART 1: 10,000 latin Squares of order 4 in reduced form:" << std::endl << std::endl;
	std::vector<std::vector<int32_t>> original_4 =
		{ { 1, 2, 3, 4 }, { 2, 1, 4, 3 }, { 3, 4, 1, 2 }, { 4, 3, 2, 1 } };
	std::map<std::vector<std::vector<int32_t>>, uint32_t> frequencies{ };
	std::vector<std::vector<std::vector<int32_t>>> cube = create_cube(original_4, 4);
	for ( uint32_t i = 1; i <= 10'000; ++i ) {
		shuffle_cube(cube);
		std::vector<std::vector<int32_t>> matrix = to_matrix(cube);
		reduce(matrix);
		frequencies[matrix]++;
	}

	for ( std::pair<std::vector<std::vector<int32_t>>, uint32_t> pair : frequencies ) {
		print_2D_vector(pair.first);
		std::cout << " occurs " << pair.second << " times" << std::endl;
	}

	std::cout << "\n" << "PART 2: 10_000 latin squares of order 5 in reduced form:" << std::endl;
		std::vector<std::vector<int32_t>> original_5 = { { 1, 2, 3, 4, 5 }, { 2, 3, 4, 5, 1 },
			                          { 3, 4, 5, 1, 2 }, { 4, 5, 1, 2, 3 }, { 5, 1, 2, 3, 4 } };
		frequencies.clear();
		cube = create_cube(original_5, 5);
		for ( uint32_t i = 1; i <= 10'000; ++i ) {
			shuffle_cube(cube);
			std::vector<std::vector<int32_t>> matrix = to_matrix(cube);
			reduce(matrix);
			frequencies[matrix]++;
		}

		uint32_t count = 0;
		for ( std::pair<std::vector<std::vector<int32_t>>, uint32_t> pair : frequencies ) {
			count++;
			std::cout << ( count > 1 ? ", " : "" ) << ( count % 8 == 1 ? "\n" : "" ) << std::setw(2) << count
					  << "(" << std::setw(3) << pair.second << ")";
		}

		std::cout << "\n\n"
				  << "PART 3: 750 latin squares of order 42, showing the last one:" << "\n" << std::endl;
		std::vector<std::vector<int32_t>> matrix_42{ };
		cube = create_cube(matrix_42, 42);
		for ( uint32_t i = 1; i <= 750; ++i ) {
			shuffle_cube(cube);
			if ( i == 750 ) {
				matrix_42 = to_matrix(cube);
			}
		}

		for ( const std::vector<int32_t>& row : matrix_42 ) {
			print_one_based_vector(row);
			std::cout << std::endl;
		}

		std::cout << "\n" << "PART 4: 1,000 latin squares of order 256:" << "\n" << std::endl;
		const auto start = std::chrono::steady_clock::now();
		std::vector<std::vector<int32_t>> empty{ };
		cube = create_cube(empty, 256);
		for ( uint32_t i = 1; i <= 1'000; ++i ) {
			shuffle_cube(cube);
		}
		const auto finish = std::chrono::steady_clock::now();
		std::cout << "Generated in " << std::chrono::duration<double, std::milli>( finish - start ).count()
				  << " milliseconds" << std::endl;
}
