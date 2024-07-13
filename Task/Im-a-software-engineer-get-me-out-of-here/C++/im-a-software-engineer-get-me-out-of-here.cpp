#include <cstdint>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

const std::string gmooh = R"(
.........00000.........
......00003130000......
....000321322221000....
...00231222432132200...
..0041433223233211100..
..0232231612142618530..
.003152122326114121200.
.031252235216111132210.
.022211246332311115210.
00113232262121317213200
03152118212313211411110
03231234121132221411410
03513213411311414112320
00427534125412213211400
.013322444412122123210.
.015132331312411123120.
.003333612214233913300.
..0219126511415312570..
..0021321524341325100..
...00211415413523200...
....000122111322000....
......00001120000......
.........00000.........)";

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

const std::vector<std::string> GMOOH = split_string(gmooh, '\n');
const int32_t WIDTH  = GMOOH[0].length();
const int32_t HEIGHT = GMOOH.size();

class Cell {
public:
	Cell(const int32_t& aRow, const int32_t& aCol) : row(aRow), col(aCol) { }

	std::string to_string() const {
		return "(" + std::to_string(row) + ", " + std::to_string(col) + ")";
	}

	int32_t row, col;
};

class Cell_With_Cost {
public:
	Cell_With_Cost(const int32_t& aFrom_Row, const int32_t& aFrom_Col, const int32_t& aCost)
	: from_row(aFrom_Row), from_col(aFrom_Col), cost(aCost) { }

	std::string to_string() const {
		return  "(" + std::to_string(from_row) + ", " + std::to_string(from_col) + " : " + std::to_string(cost) + ")";
	}

	bool operator==(const Cell_With_Cost& other) const {
		return cost == other.cost && from_row == other.from_row && from_col == other.from_col;
	}

	int32_t from_row, from_col,	cost;
};

const Cell_With_Cost ZERO_CELL_WITH_COST = Cell_With_Cost(0, 0, 0);

const std::vector<Cell> directions = { Cell(1, -1),  Cell(1, 0),  Cell(1, 1),
            						   Cell(0, -1),               Cell(0, 1),
            						   Cell(-1, -1), Cell(-1, 0), Cell(-1, 1) };

std::vector<std::vector<Cell_With_Cost>> routes = { };

void print_vector(const std::vector<Cell>& cells) {
    std::cout << "[";
    for ( uint64_t i = 0; i < cells.size() - 1; ++i ) {
    	std::cout << cells[i].to_string() << ", ";
    }
    std::cout << cells.back().to_string() << "]" << std::endl;
}

std::vector<Cell> create_route_to_cell(int32_t row, int32_t col) {
	std::vector<Cell> route = { };
	route.emplace_back(Cell(row, col));

	while ( true ) {
		Cell_With_Cost current_cell = routes[row][col];
		if ( current_cell.cost == 0 ) {
			break;
		}

		row = current_cell.from_row;
		col = current_cell.from_col;
		route.insert(route.begin(), Cell(row, col));
	}
	return route;
}

void show_cells_with_longest_route_from_HQ() {
	int32_t maximum_cost = INT_MIN;
	std::vector<Cell> cells = { };
	for ( int32_t col = 0; col < WIDTH; ++col ) {
		for ( int32_t row = 0; row < HEIGHT; ++row ) {
			if ( GMOOH[row][col] >= '0' ) {
				Cell_With_Cost current_cell = routes[row][col];
				if ( ! ( current_cell == ZERO_CELL_WITH_COST ) ) {
					const int32_t cost = current_cell.cost;
					if ( cost >= maximum_cost) {
						if ( cost > maximum_cost ) {
							cells.clear();
							maximum_cost = cost;
						}
						cells.emplace_back(Cell(row, col));
					}
				}
			}
		}
	}

	std::cout << "There are " << cells.size() << " cells that require " << maximum_cost
			  << " days to receive reinforcements from HQ:" << std::endl;
	for ( const Cell& cell : cells ) {
		print_vector(create_route_to_cell(cell.row, cell.col));
	}
}

void show_unreachable_cells() {
	std::vector<Cell> unreachableCells = { };
	for ( int32_t col = 0; col < WIDTH; ++col ) {
		for ( int32_t row = 0; row < HEIGHT; ++row ) {
			if ( GMOOH[row][col] >= '0' && routes[row][col] == ZERO_CELL_WITH_COST ) {
				unreachableCells.emplace_back(Cell(row, col));
			}
		}
	}

	std::cout << "The following cells are unreachable:" << std::endl;
	print_vector(unreachableCells);
}

void search_from_cell(int32_t row, int32_t col) {
	routes = { static_cast<uint64_t>(HEIGHT), std::vector<Cell_With_Cost>(WIDTH, ZERO_CELL_WITH_COST) };
	routes[row][col] = Cell_With_Cost(row, col, 0);

	std::vector<Cell_With_Cost> route = { };
	int32_t cost = 0;

	while ( true ) {
		const int32_t start_digit = GMOOH[row][col] - '0';
		for ( Cell direction : directions ) {
			const int32_t next_row = row + start_digit * direction.row;
			const int32_t next_col = col + start_digit * direction.col;
			if ( next_col >= 0 && next_col < WIDTH && next_row >= 0 && next_row < HEIGHT
                && GMOOH[next_row][next_col] >= '0' ) {
				Cell_With_Cost current_cell = routes[next_row][next_col];
				if ( current_cell == ZERO_CELL_WITH_COST || current_cell.cost > cost + 1 ) {
					routes[next_row][next_col] = Cell_With_Cost(row, col, cost + 1);
					if ( GMOOH[next_row][next_col] > '0' ) {
						route.emplace_back(Cell_With_Cost(next_row, next_col, cost + 1));
					}
				}
			}
		}

		if ( route.empty() ) { // All routes have been searched
			break;
		}

		Cell_With_Cost next_cell = route.front();
		route.erase(route.begin());
		row = next_cell.from_row;
		col = next_cell.from_col;
		cost = next_cell.cost;
	 }
}

void show_shortest_routes_to_safety() {
	int32_t minimum_cost = INT_MAX;
	std::vector<Cell> route = { };
	for ( int32_t col = 0; col < WIDTH; ++col ) {
	    for ( int32_t row = 0; row < HEIGHT; ++row ) {
	    	if ( GMOOH[row][col] == '0' ) {
				Cell_With_Cost current_cell = routes[row][col];
				if ( ! ( current_cell == ZERO_CELL_WITH_COST ) ) {
					const int32_t cost = current_cell.cost;
					if ( cost <= minimum_cost ) {
						if ( cost < minimum_cost ) {
							route.clear();
							minimum_cost = cost;
						}
						route.emplace_back(Cell(row, col));
					}
				}
			}
	    }
	}

	const std::string are_is  = ( route.size() > 1 ) ? "are " : "is ";
	const std::string plural = ( route.size() > 1 ) ? "s" : "";
	std::cout << "There " << are_is << route.size() << " shortest route" << plural
			  << " of " << minimum_cost << " days to safety:" << std::endl;
	for ( const Cell& cell : route ) {
		print_vector(create_route_to_cell(cell.row, cell.col));
	}
}

int main() {
	search_from_cell(11, 11);
	show_shortest_routes_to_safety();
	std::cout << std::endl;

	search_from_cell(21, 11);
	std::cout << "The shortest route from (21, 11) to (1, 11):" << std::endl;
	print_vector((create_route_to_cell(1, 11)));
	std::cout << std::endl;

	search_from_cell(1, 11);
	std::cout << "The shortest route from (1, 11) to (21, 11):" << std::endl;
	print_vector((create_route_to_cell(21, 11)));
	std::cout << std::endl;

	search_from_cell(11, 11);
	show_unreachable_cells();
	std::cout << std::endl;

	show_cells_with_longest_route_from_HQ();
}
