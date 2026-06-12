#include <cmath>
#include <cstdint>
#include <iostream>
#include <functional>
#include <stdexcept>
#include <vector>

std::vector<std::vector<double>> to_reduced_row_echelon_form(std::vector<std::vector<double>> vec) {
	const uint32_t row_count = vec.size();
	const uint32_t col_count = vec[0].size();

	uint32_t lead = 0;
	for ( uint32_t row = 0; row < row_count; ++row ) {
		if ( col_count <= lead ) { return vec; }
		uint32_t i = row;

		while ( vec[i][lead] == 0 ) {
			i += 1;
			if ( row_count == i ) {
				i = row;
				lead += 1;
				if ( col_count == lead ) { return vec; }
			}
		}

		const std::vector<double> temp = vec[i]; vec[i] = vec[row]; vec[row] = temp;

		if ( vec[row][lead] != 0 ) {
			const double divisor = vec[row][lead];
			for ( uint32_t col = 0; col < col_count; ++col ) {
				vec[row][col] /= divisor;
			}
		}

		for ( uint32_t k = 0; k < row_count; ++k ) {
			if ( k != row ) {
				const double multiplier = vec[k][lead];
				for ( uint32_t j = 0; j < col_count; ++j ) {
					vec[k][j] -= vec[row][j] * multiplier;
				}
			}
		}

		lead += 1;
	}
	return vec;
}

std::vector<std::vector<double>> inverse(const std::vector<std::vector<double>>& vec) {
	if ( vec.size() != vec[0].size() ) {
		throw std::invalid_argument("Not a square vector");
	}

	const uint32_t size = vec.size();
	std::vector<std::vector<double>> augmented(size, std::vector<double>(2 * size, 0.0));
	for ( uint32_t row = 0; row < size; ++row ) {
		for ( uint32_t col = 0; col < size; ++col ) {
			augmented[row][col] = vec[row][col];
		}
		// Copy identity matrix to the right hand side of augmented matrix
		augmented[row][row + size] = 1.0;
	}

	augmented = to_reduced_row_echelon_form(augmented);
	std::vector<std::vector<double>> result(size, std::vector<double>(size, 0.0));
	// Copy inverse matrix from right hand side of augmented matrix
	for ( uint32_t row = 0; row < size; ++row ) {
		for ( uint32_t col = 0; col < size; ++col ) {
			result[row][col] = augmented[row][col + size];
		}
	}
	return result;
}

std::vector<std::vector<double>> multiply(const std::vector<std::vector<double>>& one,
										  const std::vector<std::vector<double>>& two) {
	if ( one[0].size() != two.size() ) {
		throw std::invalid_argument("Incompatible vector sizes");
	}

	const uint32_t row_count = one.size();
	const uint32_t col_count = two[0].size();
	std::vector<std::vector<double>> result(row_count, std::vector<double>(col_count, 0.0));
	for ( uint32_t row = 0; row < row_count; ++row ) {
		for ( uint32_t col = 0; col < col_count; ++col ) {
			for ( uint32_t k = 0; k < row_count; ++k ) {
				result[row][col] += one[row][k] * two[k][col];
			}
		}
	}
	return result;
}

std::vector<double> solve(
		const std::vector<std::function<double(std::vector<double>)>>& functions,
		const std::vector<std::vector<std::function<double(std::vector<double>)>>>& jacobian,
		std::vector<double> values) {

	const uint32_t size = functions.size();
	const double epsilon = 0.000'000'08;
	const uint32_t maxIterations = 4;
	uint32_t iteration = 0;
	double maxChange = 0.0;

	while ( iteration < maxIterations || maxChange < epsilon ) {
		std::vector<std::vector<double>> column(size, std::vector<double>(1, 0.0));
		for ( uint32_t i = 0; i < size; ++i ) {
			column[i][0] = functions[i](values);
		}

		std::vector<std::vector<double>> jac(size, std::vector<double>(values.size(), 0.0));
		for ( uint32_t i = 0; i < size; ++i ) {
			for ( uint32_t j = 0; j < size; ++j ) {
				jac[i][j] = jacobian[i][j](values);
			}
		}

		const std::vector<std::vector<double>> jacInverse = inverse(jac);
		std::vector<std::vector<double>> delta = multiply(jacInverse, column);

		for ( uint32_t i = 0; i < size; ++i ) {
			values[i] -= delta[i][0];
			if ( std::abs(delta[i][0]) > maxChange ) {
				maxChange = std::abs(delta[i][0]);
			}
		}

		iteration += 1;
	}
	return values;
}

int main() {
	/**
	 * Solve the two non-linear equations:
	 *    y + x^2 - x - 0.5 = 0
	 *    y + 5xy - x^2 = 0
	 *    with initial values of x = 1.2, y = 1.2
	 */
	std::vector<std::function<double(std::vector<double>)>> functions = {
		[](const std::vector<double>& a) { return a[1] + a[0] * a[0] - a[0] - 0.5; },
		[](const std::vector<double>& a) { return a[1] + 5.0 * a[0] * a[1] - a[0] * a[0]; }
	};

	std::vector<std::vector<std::function<double(std::vector<double>)>>> jacobian = {
		{ [](const std::vector<double>& a) { return 2.0 * a[0] - 1.0; },
		  [](const std::vector<double>& a) { return 1.0; }
		},
		{ [](const std::vector<double>& a) { return 5.0 * a[1] - 2.0 * a[0]; },
		  [](const std::vector<double>& a) { return 1.0 + 5.0 * a[0]; }
		}
	};

	std::vector<double> initial_values = { 1.2, 1.2 };

	std::vector<double> result = solve(functions, jacobian, initial_values);
	std::cout << "x = " << result[0] << ", y = " << result[1] << std::endl;

	/**
	 * Solve the three non-linear equations:
	 *  9x^2 + 36y^2 + 4z^2 - 36 = 0
	 *  x^2 - 2y^2 - 20z = 0
	 *  x^2 - y^2 + z^2 = 0
	 *  with initial values of x = 1.0, y = 1.0 and z = 0.0
	 */
	functions = {
		[](const std::vector<double>& a)
			{ return 9.0 * a[0] * a[0] + 36 * a[1] * a[1] + 4 * a[2] * a[2] - 36.0; },
		[](const std::vector<double>& a) { return a[0] * a[0] - 2.0 * a[1] * a[1] - 20.0 * a[2]; },
		[](const std::vector<double>& a) { return a[0] * a[0] - a[1] * a[1] + a[2] * a[2] ; }
	};

	jacobian = {
		{ [](const std::vector<double>& a) { return 18.0 * a[0]; },
		  [](const std::vector<double>& a) { return 72.0 * a[1]; },
		  [](const std::vector<double>& a) { return 8.0 * a[2]; }
		},
		{ [](const std::vector<double>& a) { return 2.0 * a[0]; },
		  [](const std::vector<double>& a) { return -4.0 * a[1]; },
		  [](const std::vector<double>& a) { return -20.0; }
		},
		{ [](const std::vector<double>& a) { return 2.0 * a[0]; },
		  [](const std::vector<double>& a) { return -2.0 * a[1]; },
		  [](const std::vector<double>& a) { return 2.0 * a[2]; }
	    }
	};

	initial_values = { 1.0, 1.0, 0.0 };

	result = solve(functions, jacobian, initial_values);
	std::cout << "x = " << result[0] << ", y = " << result[1] << ", z = " << result[2] <<std::endl;
}
