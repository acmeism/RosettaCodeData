// Much shorter than the version below;
// uses C++11 threads to parallelize the computation; also uses backtracking
// Outputs all solutions for any table size
#include <vector>
#include <iostream>
#include <iomanip>
#include <thread>
#include <future>

// Print table. 'pos' is a vector of positions – the index in pos is the row,
// and the number at that index is the column where the queen is placed.
static void print(const std::vector<int> &pos)
{
	// print table header
	for (int i = 0; i < pos.size(); i++) {
		std::cout << std::setw(3) << char('a' + i);
	}

	std::cout << '\n';

	for (int row = 0; row < pos.size(); row++) {
		int col = pos[row];
		std::cout << row + 1 << std::setw(3 * col + 3) << " # ";
		std::cout << '\n';
	}

	std::cout << "\n\n";
}

static bool threatens(int row_a, int col_a, int row_b, int col_b)
{
	return row_a == row_b // same row
		or col_a == col_b // same column
		or std::abs(row_a - row_b) == std::abs(col_a - col_b); // diagonal
}

// the i-th queen is in the i-th row
// we only check rows up to end_idx
// so that the same function can be used for backtracking and checking the final solution
static bool good(const std::vector<int> &pos, int end_idx)
{
	for (int row_a = 0; row_a < end_idx; row_a++) {
		for (int row_b = row_a + 1; row_b < end_idx; row_b++) {
			int col_a = pos[row_a];
			int col_b = pos[row_b];
			if (threatens(row_a, col_a, row_b, col_b)) {
				return false;
			}
		}
	}

	return true;
}

static std::mutex print_count_mutex; // mutex protecting 'n_sols'
static int n_sols = 0; // number of solutions

// recursive DFS backtracking solver
static void n_queens(std::vector<int> &pos, int index)
{
	// if we have placed a queen in each row (i. e. we are at a leaf of the search tree), check solution and return
	if (index >= pos.size()) {
		if (good(pos, index)) {
			std::lock_guard<std::mutex> lock(print_count_mutex);
			print(pos);
			n_sols++;
		}

		return;
	}

	// backtracking step
	if (not good(pos, index)) {
		return;
	}

	// optimization: the first level of the search tree is parallelized
	if (index == 0) {
		std::vector<std::future<void>> fts;
		for (int col = 0; col < pos.size(); col++) {
			pos[index] = col;
			auto ft = std::async(std::launch::async, [=]{ auto cpos(pos); n_queens(cpos, index + 1); });
			fts.push_back(std::move(ft));
		}

		for (const auto &ft : fts) {
			ft.wait();
		}
	} else { // deeper levels are not
		for (int col = 0; col < pos.size(); col++) {
			pos[index] = col;
			n_queens(pos, index + 1);
		}
	}
}

int main()
{
	std::vector<int> start(12); // 12: table size
	n_queens(start, 0);
	std::cout << n_sols << " solutions found.\n";
	return 0;
}
