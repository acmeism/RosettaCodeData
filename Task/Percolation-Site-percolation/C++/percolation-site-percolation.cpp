#include <iostream>
#include <vector>
#include <string>
#include <random>
#include <iomanip>

std::random_device random;
std::mt19937 generator(random());
std::uniform_real_distribution<double> distribution(0.0F, 1.0F);

class Grid {
public:
	Grid(const int32_t row_count, const int32_t col_count, const double probability) {
		create_table(row_count, col_count, probability);
	}

	bool percolate() {
		for ( int32_t x = 0; x < (int32_t) table[0].size(); ++x ) {
			if ( path_exists(x, 0) ) {
				return true;
			}
		}
		return false;
	}

	void display() const {
	for ( uint64_t col = 0; col < table.size(); ++col ) {
		for ( uint64_t row = 0; row < table[0].size(); ++row ) {
			std::cout << " " << table[col][row];
		}
		std::cout << std::endl;
	}
	std::cout << std::endl;
}
private:
	bool path_exists(const int32_t x, const int32_t y) {
		if ( y < 0 || x < 0 || x >= (int32_t) table[0].size() || table[y][x].compare(FILLED) != 0 ) {
			return false;
		}
		table[y][x] = PATH;
		if ( y == (int32_t) table.size() - 1 ) {
			return true;
		}
		return path_exists(x, y + 1) || path_exists(x + 1, y) || path_exists(x - 1, y) || path_exists(x, y - 1);
	}

	void create_table(const int32_t row_count, const int32_t col_count, const double probability) {
		table.assign(row_count, std::vector<std::string>(col_count, EMPTY));
		for ( int32_t col = 0; col < row_count; ++col ) {
			for ( int32_t row = 0; row < col_count; ++row ) {
				table[col][row] = ( distribution(generator) < probability ) ? FILLED: EMPTY;
			}
		}
	}

	std::vector<std::vector<std::string>> table;
	inline static const std::string EMPTY = " ";
	inline static const std::string FILLED = ".";
	inline static const std::string PATH = "#";
};

int main() {
	const int32_t row_count = 15;
	const int32_t col_count = 15;
	const int32_t test_count = 1'000;

	Grid grid(row_count, col_count, 0.5);
	grid.percolate();
	grid.display();

	std::cout << "Proportion of " << test_count << " tests that percolate through the grid:" << std::endl;
	for ( double probable = 0.0; probable <= 1.0; probable += 0.1 ) {
		double percolation_count = 0.0;
		for ( int32_t test = 0; test < test_count; ++test ) {
			Grid test_grid(row_count, col_count, probable);
			if ( test_grid.percolate() ) {
				percolation_count += 1.0;
			}
		}
		const double percolation_proportion = percolation_count / test_count;
		std::cout << " p = " << std::setprecision(1) <<std::fixed << probable << " : "
				  << std::setprecision(4) << percolation_proportion << std::endl;
	}
}
