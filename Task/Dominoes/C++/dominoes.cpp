#include <algorithm>
#include <cstdint>
#include <iostream>
#include <string>
#include <vector>

const int32_t EMPTY = -1;

const std::vector<std::vector<int32_t>> tableau_one = { { 0, 5, 1, 3, 2, 2, 3, 1 },
												        { 0, 5, 5, 0, 5, 2, 4, 6 },
												        { 4, 3, 0, 3, 6, 6, 2, 0 },
	                                                    { 0, 6, 2, 3, 5, 1, 2, 6 },
	                                                    { 1, 1, 3, 0, 0, 2, 4, 5 },
	                                                    { 2, 1, 4, 3, 3, 4, 6, 6 },
	                                                    { 6, 4, 5, 1, 5, 4, 1, 4 } };

const std::vector<std::vector<int32_t>> tableau_two = { { 6, 4, 2, 2, 0, 6, 5, 0 },
	                                                    { 1, 6, 2, 3, 4, 1, 4, 3 },
														{ 2, 1, 0, 2, 3, 5, 5, 1 },
														{ 1, 3, 5, 0, 5, 6, 1, 0 },
														{ 4, 2, 6, 0, 4, 0, 1, 1 },
														{ 4, 4, 2, 0, 5, 3, 6, 3 },
														{ 6, 6, 5, 2, 5, 3, 3, 4 } };

class Domino {
public:
	Domino(const int32_t& aOne, const int32_t& aTwo) {
		one = std::min(aOne, aTwo);
		two = std::max(aOne, aTwo);
	}

	bool operator==(const Domino& other) const {
		return one == other.one && two == other.two;
	}

private:
	int32_t one, two;

};

class Point {
public:
	Point(const int32_t& aX, const int32_t& aY) : x(aX), y(aY) { }

	bool operator==(const Point& other) const {
		return x == other.x && y == other.y;
	}

	int32_t x, y;
};

struct Pattern {
	std::vector<std::vector<int32_t>> tableau;
	std::vector<Domino> dominoes;
	std::vector<Point> points;
};

int32_t first_empty_cell(const std::vector<std::vector<int32_t>>& tableau) {
	for ( uint64_t row = 0; row < tableau.size(); ++row ) {
		for ( uint64_t col = 0; col < tableau[0].size(); ++col ) {
			if ( tableau[row][col] == EMPTY ) {
				return row * tableau[0].size() + col;
			}
		}
	}
	return EMPTY;
}

void print_layout(const Pattern& pattern) {
	std::vector<std::string> output(
        2 * pattern.tableau.size(), std::string(2 * pattern.tableau[0].size() - 1, ' '));

	for ( uint64_t i = 0; i < pattern.points.size() - 1; i += 2 ) {
		const int x1 = pattern.points[i].x;
		const int y1 = pattern.points[i].y;
		const int x2 = pattern.points[i + 1].x;
		const int y2 = pattern.points[i + 1].y;
		const int n1 = pattern.tableau[x1][y1];
		const int n2 = pattern.tableau[x2][y2];
		output[2 * x1][2 * y1] = static_cast<char>('0' + n1);
		output[2 * x2][2 * y2] = static_cast<char>('0' + n2);
		if ( x1 == x2 ) {
			output[2 * x1][2 * y1 + 1] = '+';
		} else if ( y1 == y2 ) {
			output[2 * x1 + 1][2 * y1] = '+';
		}
	}

	for ( const std::string& line : output ) {
		std::cout << line << "\n";
	}
}

std::vector<Pattern> find_patterns(const std::vector<std::vector<int32_t>>& tableau) {
	const int32_t n_rows = tableau.size();
	const int32_t n_cols = tableau[0].size();
	const uint64_t domino_count = ( n_rows * n_cols ) / 2;
	std::vector<std::vector<int32_t>> empty_tableau =
        { static_cast<uint64_t>(n_rows), std::vector<int32_t>(n_cols, EMPTY) };
	std::vector<Pattern> patterns = { Pattern(empty_tableau, std::vector<Domino>(), std::vector<Point>()) };

	while ( true ) {
		std::vector<Pattern> next_patterns = { };
		for ( Pattern pattern : patterns ) {
			std::vector<std::vector<int32_t>> next_tableau = pattern.tableau;
			std::vector<Domino> dominoes = pattern.dominoes;
			std::vector<Point> points = pattern.points;

			int32_t index = first_empty_cell(next_tableau);
			if ( index == EMPTY ) {
				continue;
			}

			int32_t row = index / n_cols;
			int32_t col = index % n_cols;
			if ( row + 1 < n_rows && next_tableau[row + 1][col] == EMPTY ) {
				Domino domino(tableau[row][col], tableau[row + 1][col]);
				if ( std::find(dominoes.begin(), dominoes.end(), domino) == dominoes.end() ) {
					std::vector<std::vector<int32_t>> final_tableau = { };
					std::copy(next_tableau.begin(), next_tableau.end(), std::back_inserter(final_tableau));
					final_tableau[row][col] = tableau[row][col];
					final_tableau[row + 1][col] = tableau[row + 1][col];
					std::vector<Domino> next_dominoes(dominoes.begin(), dominoes.end());
					next_dominoes.emplace_back(domino);
					std::vector<Point> next_points(points.begin(), points.end());
					next_points.emplace_back(Point(row, col));
					next_points.emplace_back(Point(row + 1, col));
					next_patterns.emplace_back(Pattern(final_tableau, next_dominoes, next_points));
				}
			}

			if ( col + 1 < n_cols && next_tableau[row][col + 1] == EMPTY ) {
				Domino domino(tableau[row][col], tableau[row][col + 1]);
				if ( std::find(dominoes.begin(), dominoes.end(), domino) == dominoes.end() ) {
					next_tableau[row][col] = tableau[row][col];
					next_tableau[row][col + 1] = tableau[row][col + 1];
					dominoes.emplace_back(domino);
					points.emplace_back(Point(row, col));
					points.emplace_back(Point(row, col + 1));
					next_patterns.emplace_back(Pattern(next_tableau, dominoes, points));
				}
			}
		}

		if ( next_patterns.empty() ) {
			break;
		}
		patterns = next_patterns;
		if ( patterns[0].dominoes.size() == domino_count ) {
			break;
		}
	}

	return patterns;
}

int main() {
	for ( const std::vector<std::vector<int32_t>>& tableau : { tableau_one, tableau_two } ) {
		std::vector<Pattern> patterns = find_patterns(tableau);
		std::cout << "Layouts found: " << patterns.size() << "\n";
		print_layout(patterns[0]);
	}
}
