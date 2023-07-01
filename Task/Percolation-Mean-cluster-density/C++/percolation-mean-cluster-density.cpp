#include <iostream>
#include <random>
#include <string>
#include <vector>
#include <iomanip>

std::random_device random;
std::mt19937 generator(random());
std::uniform_real_distribution<double> distribution(0.0F, 1.0F);

class Grid {
public:
	Grid(const int32_t size, const double probability) {
		create_grid(size, probability);
		count_clusters();
	}

	int32_t cluster_count() const {
		return clusters;
	}

	double cluster_density() const {
		return (double) clusters / ( grid.size() * grid.size() );
	}

	void display() const {
		for ( uint64_t row = 0; row < grid.size(); ++row ) {
			for ( uint64_t col = 0; col < grid.size(); ++col ) {
				uint64_t value = grid[row][col];
				char ch = ( value < GRID_CHARACTERS.length() ) ? GRID_CHARACTERS[value] : '?';
				std::cout << " " << ch;
			}
			std::cout << std::endl;
		}
	}
private:
	void count_clusters() {
		clusters = 0;
		for ( uint64_t row = 0; row < grid.size(); ++row ) {
			for ( uint64_t col = 0; col < grid.size(); ++col ) {
				if ( grid[row][col] == CLUSTERED ) {
					clusters += 1;
					identify_cluster(row, col, clusters);
				}
			}
		}
	}

	void identify_cluster(const uint64_t row, const uint64_t col, const uint64_t count) {
		grid[row][col] = count;
		if ( row < grid.size() - 1 && grid[row + 1][col] == CLUSTERED ) {
			identify_cluster(row + 1, col, count);
		}
		if ( col < grid.size() - 1 && grid[row][col + 1] == CLUSTERED ) {
			identify_cluster(row, col + 1, count);
		}
		if ( col > 0 && grid[row][col - 1] == CLUSTERED ) {
			identify_cluster(row, col - 1, count);
		}
		if ( row > 0 && grid[row - 1][col] == CLUSTERED ) {
			identify_cluster(row - 1, col, count);
		}
	}

	void create_grid(int32_t grid_size, double probability) {
		grid.assign(grid_size, std::vector<int32_t>(grid_size, 0));
		for ( int32_t row = 0; row < grid_size; ++row ) {
			for ( int32_t col = 0; col < grid_size; ++col ) {
				if ( distribution(generator) < probability ) {
					grid[row][col] = CLUSTERED;
				}
			}
		}
	}

	int32_t clusters;
	std::vector<std::vector<int32_t>> grid;

	inline static const int CLUSTERED = -1;
	inline static const std::string GRID_CHARACTERS = ".ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
};

int main() {
	const int32_t size = 15;
	const double probability = 0.5;
	const int32_t test_count = 5;

	Grid grid(size, probability);
	std::cout << "This " << size << " by " << size << " grid contains "
			  << grid.cluster_count() << " clusters:" << std::endl;
	grid.display();

	std::cout << "\n p = 0.5, iterations = " << test_count << std::endl;
	std::vector<int32_t> grid_sizes = { 10, 100, 1'000, 10'000 };
	for ( int32_t grid_size : grid_sizes ) {
		double sumDensity = 0.0;
		for ( int32_t test = 0; test < test_count; test++ ) {
			Grid grid(grid_size, probability);
			sumDensity += grid.cluster_density();
		}
		double result = sumDensity / test_count;
		std::cout << " n = " << std::setw(5) << grid_size
				  << ", simulations K = " << std::fixed << result << std::endl;
	}
}
