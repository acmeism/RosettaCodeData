#include <cstdint>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

constexpr int32_t MAXIMUM_VALUE = 2'147'483'647;

std::vector<std::vector<int32_t>> cost;
std::vector<std::vector<int32_t>> order;

void print_vector(const std::vector<int32_t>& list) {
	std::cout << "[";
	for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] << ", ";
	}
	std::cout << list.back() << "]" << std::endl;
}

int32_t matrix_chain_order(const std::vector<int32_t>& dimensions) {
	const uint64_t size = dimensions.size() - 1;
	cost = { size, std::vector<int32_t>(size, 0) };
	order = { size, std::vector<int32_t>(size, 0) };

	for ( uint64_t m = 1; m < size; ++m ) {
		for ( uint64_t i = 0; i < size - m; ++i ) {
			int32_t j = i + m;
			cost[i][j] = MAXIMUM_VALUE;
			for ( int32_t k = i; k < j; ++k ) {
				int32_t current_cost = cost[i][k] + cost[k + 1][j]
					+ dimensions[i] * dimensions[k + 1] * dimensions[j + 1];
				if ( current_cost < cost[i][j] ) {
					cost[i][j] = current_cost;
					order[i][j] = k;
				}
			}
		}
	}
	return cost[0][size - 1];
}

std::string get_optimal_parenthesizations(const std::vector<std::vector<int32_t>>& order,
										  const uint64_t& i, const uint64_t& j) {
	if ( i == j ) {
		std::string result(1, char(i + 65));
		return result;
	} else {
		std::stringstream stream;
		stream << "(" << get_optimal_parenthesizations(order, i, order[i][j])
			   << " * " << get_optimal_parenthesizations(order, order[i][j] + 1, j) << ")";
		return stream.str();
	}
}

void matrix_chain_multiplication(const std::vector<int32_t>& dimensions) {
	std::cout << "Array Dimension  = "; print_vector(dimensions);
	std::cout << "Cost             = " << matrix_chain_order(dimensions) << std::endl;
	std::cout << "Optimal Multiply = "
			  <<  get_optimal_parenthesizations(order, 0, order.size() - 1) << std::endl << std::endl;
}

int main() {
	matrix_chain_multiplication({ 5, 6, 3, 1 });
	matrix_chain_multiplication({ 1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2 });
	matrix_chain_multiplication({ 1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10 });
}
