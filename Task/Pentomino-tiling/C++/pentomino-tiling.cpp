#include <algorithm>
#include <cstdint>
#include <iostream>
#include <random>
#include <vector>

const std::vector<std::vector<int32_t>> F = { { 1, -1, 1, 0, 1, 1, 2, 1 }, { 0, 1, 1, -1, 1, 0, 2, 0 },
    { 1, 0, 1, 1, 1, 2, 2, 1 }, { 1, 0, 1, 1, 2, -1, 2, 0 }, { 1, -2, 1, -1, 1, 0, 2, -1 },
    { 0, 1, 1, 1, 1, 2, 2, 1 }, { 1, -1, 1, 0, 1, 1, 2, -1 }, { 1, -1, 1, 0, 2, 0, 2, 1 } };

const std::vector<std::vector<int32_t>> I = { { 0, 1, 0, 2, 0, 3, 0, 4 }, { 1, 0, 2, 0, 3, 0, 4, 0 } };

const std::vector<std::vector<int32_t>> L = { { 1, 0, 1, 1, 1, 2, 1, 3 }, { 1, 0, 2, 0, 3, -1, 3, 0 },
    { 0, 1, 0, 2, 0, 3, 1, 3 }, { 0, 1, 1, 0, 2, 0, 3, 0 }, { 0, 1, 1, 1, 2, 1, 3, 1 },
    { 0, 1, 0, 2, 0, 3, 1, 0 }, { 1, 0, 2, 0, 3, 0, 3, 1 }, { 1, -3, 1, -2, 1, -1, 1, 0 } };

const std::vector<std::vector<int32_t>> N = { { 0, 1, 1, -2, 1, -1, 1, 0 }, { 1, 0, 1, 1, 2, 1, 3, 1 },
    { 0, 1, 0, 2, 1, -1, 1, 0 }, { 1, 0, 2, 0, 2, 1, 3, 1 }, { 0, 1, 1, 1, 1, 2, 1, 3 },
    { 1, 0, 2, -1, 2, 0, 3, -1 }, { 0, 1, 0, 2, 1, 2, 1, 3 }, { 1, -1, 1, 0, 2, -1, 3, -1 } };

const std::vector<std::vector<int32_t>> P = { { 0, 1, 1, 0, 1, 1, 2, 1 }, { 0, 1, 0, 2, 1, 0, 1, 1 },
    { 1, 0, 1, 1, 2, 0, 2, 1 }, { 0, 1, 1, -1, 1, 0, 1, 1 }, { 0, 1, 1, 0, 1, 1, 1, 2 },
    { 1, -1, 1, 0, 2, -1, 2, 0 }, { 0, 1, 0, 2, 1, 1, 1, 2 }, { 0, 1, 1, 0, 1, 1, 2, 0 } };

const std::vector<std::vector<int32_t>> T = { { 0, 1, 0, 2, 1, 1, 2, 1 }, { 1, -2, 1, -1, 1, 0, 2, 0 },
    { 1, 0, 2, -1, 2, 0, 2, 1 }, { 1, 0, 1, 1, 1, 2, 2, 0 } };

const std::vector<std::vector<int32_t>> U = { { 0, 1, 0, 2, 1, 0, 1, 2 }, { 0, 1, 1, 1, 2, 0, 2, 1 },
    { 0, 2, 1, 0, 1, 1, 1, 2 }, { 0, 1, 1, 0, 2, 0, 2, 1 } };

const std::vector<std::vector<int32_t>> V = { { 1, 0, 2, 0, 2, 1, 2, 2 }, { 0, 1, 0, 2, 1, 0, 2, 0 },
    { 1, 0, 2, -2, 2, -1, 2, 0 }, { 0, 1, 0, 2, 1, 2, 2, 2 } };

const std::vector<std::vector<int32_t>> W = { { 1, 0, 1, 1, 2, 1, 2, 2 }, { 1, -1, 1, 0, 2, -2, 2, -1 },
    { 0, 1, 1, 1, 1, 2, 2, 2 }, { 0, 1, 1, -1, 1, 0, 2, -1 } };

const std::vector<std::vector<int32_t>> X = { { 1, -1, 1, 0, 1, 1, 2, 0 } };

const std::vector<std::vector<int32_t>> Y = { { 1, -2, 1, -1, 1, 0, 1, 1 }, { 1, -1, 1, 0, 2, 0, 3, 0 },
    { 0, 1, 0, 2, 0, 3, 1, 1 }, { 1, 0, 2, 0, 2, 1, 3, 0 }, { 0, 1, 0, 2, 0, 3, 1, 2 },
    { 1, 0, 1, 1, 2, 0, 3, 0 }, { 1, -1, 1, 0, 1, 1, 1, 2 }, { 1, 0, 2, -1, 2, 0, 3, 0 } };

const std::vector<std::vector<int32_t>> Z = { { 0, 1, 1, 0, 2, -1, 2, 0 }, { 1, 0, 1, 1, 1, 2, 2, 2 },
    { 0, 1, 1, 1, 2, 1, 2, 2 }, { 1, -2, 1, -1, 1, 0, 2, -2 } };

const int32_t blank_index = 12;
const int32_t nRows = 8;
const int32_t nCols = 8;

std::vector<std::vector<std::vector<int32_t>>> shapes = { F, I, L, N, P, T, U, V, W, X, Y, Z };
std::vector<char> symbols = { 'F', 'I', 'L', 'N', 'P', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '-' };
std::vector<std::vector<int32_t>> grid{nRows, std::vector<int32_t>(nCols, -1)};
std::vector<bool> placed(symbols.size() - 1, false);

std::random_device random;
std::mt19937 generator(random());
std::uniform_real_distribution<double> distribution(0.0F, 1.0F);

void display() {
   for ( const std::vector<int32_t>& row : grid ) {
	   for ( const int32_t& index : row ) {
		   std::cout << symbols[index] << " ";
	   }
	   std::cout << std::endl;
   }
}

void shuffle_shapes() {
	uint64_t size = shapes.size();
	while ( size > 1 ) {
		int32_t random = static_cast<int32_t>( distribution(generator) * ( size-- ) );

		const std::vector<std::vector<int32_t>> temp = shapes[random];
		shapes[random] = shapes[size];
		shapes[size] = temp;

		const char temp_symbol = symbols[random];
		symbols[random] = symbols[size];
		symbols[size] = temp_symbol;
	}
}

bool place_orientation(const std::vector<int32_t>& orientation,
                       const int32_t& row, const int32_t& col, const int32_t& shape_index) {
	for ( uint64_t i = 0; i < orientation.size(); i += 2 ) {
		int32_t x = col + orientation[i + 1];
		int32_t y = row + orientation[i];
		if ( x < 0 || x >= nCols || y < 0 || y >= nRows || grid[y][x] != -1 ) {
			return false;
		}
	}

	grid[row][col] = shape_index;
	for ( uint64_t i = 0; i < orientation.size(); i += 2 ) {
		grid[row + orientation[i]][col + orientation[i + 1]] = shape_index;
	}
	return true;
}

void remove_orientation(const std::vector<int32_t>& oorientation, const int32_t& row, const int32_t& col) {
	grid[row][col] = -1;
	for ( uint64_t i = 0; i < oorientation.size(); i += 2 ) {
		grid[row + oorientation[i]][col + oorientation[i + 1]] = -1;
	}
}

bool solve(const int32_t& position, const uint64_t& number_placed) {
   if ( number_placed == shapes.size() ) {
	   return true;
   }

   int32_t row = position / nCols;
   int32_t col = position % nCols;

   if ( grid[row][col] != -1 ) {
	   return solve(position + 1, number_placed);
   }

   for ( uint64_t i = 0; i < shapes.size(); ++i ) {
	   if ( ! placed[i] ) {
		   for ( const std::vector<int32_t>& orientation : shapes[i] ) {
			   if ( ! place_orientation(orientation, row, col, i) ) {
				   continue;
			   }

			   placed[i] = true;

			   if ( solve(position + 1, number_placed + 1) ) {
				   return true;
			   }

			   remove_orientation(orientation, row, col);
			   placed[i] = false;
		   }
	   }
   }
   return false;
}

int main() {
	shuffle_shapes();

	for ( int32_t i = 0; i < 4; ++i ) {
		int32_t random_row, random_col;
		do {
			random_row = static_cast<int32_t>(distribution(generator) * nRows);
			random_col = static_cast<int32_t>(distribution(generator) * nCols);
		} while ( grid[random_row][random_col] == blank_index );

		grid[random_row][random_col] = blank_index;

	}

	if ( solve(0, 0) ) {
		display();
	} else {
		std::cout << "No solution found" << std::endl;
	}
}
